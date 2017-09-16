import React, { Component } from 'react'
import SimpleStorageContract from '../build/contracts/SimpleStorage.json'
import DeckContract from '../build/contracts/Deck.json'
import getWeb3 from './utils/getWeb3'

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'



const contract = require('truffle-contract')
const simpleStorage = contract(SimpleStorageContract)
const deck = contract(DeckContract)


class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      storageValue: 0,
      web3: null,
      result: null,
      deckInstance: null,
      account: null,
      seat1: 'nobus/flipside.png',
      seat2: 'nobus/flipside.png',
      seat3: 'nobus/flipside.png',
      seat4: 'nobus/flipside.png',
      stack: [0, 0, 0, 0],
    };


    this.mySeat = -1;

    //this.receiveCards = this.receiveCards.bind(this);
    this.deal = this.deal.bind(this);
    //this.increase = this.increase.bind(this);
    this.winner = this.winner.bind(this);
    this.shuffle = this.shuffle.bind(this);
    this.takeSeat = this.takeSeat.bind(this);
    this.bet = this.bet.bind(this);

  }

  componentWillMount() {

    getWeb3
    .then(results => {

      results.web3.eth.defaultAccount = results.web3.eth.accounts[0];

      this.setState({
        web3: results.web3
      });

      this.instantiateContract()
    })
    .catch(() => {
      console.log('Error finding web3.')
    });
  }

  instantiateContract() {


    deck.setProvider(this.state.web3.currentProvider);

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {
      this.setState({account: accounts[1]})
    
      deck.deployed().then((instance)=>{
        this.setState({ deckInstance: instance });
        instance.SendStack().watch((err, event) => {
          console.log(event.args.chips.toNumber());

          var temp = this.state.stack.slice();
          temp[event.args.seat.toNumber()] = event.args.chips.toNumber();
          this.setState({stack: temp.slice()});
        });

        instance.Deal().watch((err, event) => {
          this.deal();
        })
      })
    })
  }


  takeSeat(seat) {
    if(seat !== -1){
      this.state.deckInstance.sitDown(seat, 1000);
      this.mySeat = seat + 1;
    } else {

      if(this.mySeat !== -1){
        console.log('stand up');
        this.state.deckInstance.standUp(this.mySeat - 1).then(() => this.mySeat = seat + 1);
      }
    }

  }

  winner() {
    this.state.deckInstance.calcWinner().then((card) => { 
      this.setState({ myCard: 'nobus/' + card + '.png' });
    });

    this.state.deckInstance.playerActive(0).then((bactive) => {  
      var active = bactive.toNumber();
      if(active === 2) {
        this.state.deckInstance.getCard(0).then((result) => this.setState({seat1: 'nobus/' + result + '.png' }));
      }
    });

    this.state.deckInstance.playerActive(1).then((bactive) => {  
      var active = bactive.toNumber();
      if(active === 2) {
        this.state.deckInstance.getCard(1).then((result) => this.setState({seat2: 'nobus/' + result + '.png' }));
      }
    });

    this.state.deckInstance.playerActive(2).then((bactive) => {  
      var active = bactive.toNumber();
      if(active === 2) {
        this.state.deckInstance.getCard(2).then((result) => this.setState({seat3: 'nobus/' + result + '.png' }));
      }
    });

    this.state.deckInstance.playerActive(3).then((bactive) => {  
      var active = bactive.toNumber();

      console.log(active);
      if(active === 2) {
        this.state.deckInstance.getCard(3).then((result) => this.setState({seat4: 'nobus/' + result + '.png' }));
      }
    });
  }

  shuffle() {
    this.state.deckInstance.shuffle({gas: 4000000}).then( () => {
      this.state.deckInstance.deal();
    })
  }

  deal() {  
    this.state.deckInstance.initGame().then(() => { 
      this.state.deckInstance.playerActive(0).then((bactive) => {  
        var active = bactive.toNumber();
        if(this.mySeat === 1 && active === 2) {
          this.setState({seat1: 'nobus/flipside.png'});
        } else if(active === 2) {
          this.state.deckInstance.getCard(0).then((result) => this.setState({seat1: 'nobus/' + result + '.png' }));
        } else {
          this.setState({seat1: 'nobus/blank.png' });
        }
      })
      
      this.state.deckInstance.playerActive(1).then((bactive) => {  
        var active = bactive.toNumber();
        if(this.mySeat === 2 && active === 2) {
          this.setState({seat2: 'nobus/flipside.png'});
        } else if(active === 2) {
          this.state.deckInstance.getCard(1).then((result) => this.setState({seat2: 'nobus/' + result + '.png' }));
        } else {
          this.setState({seat2: 'nobus/blank.png'});
        }
      })

      this.state.deckInstance.playerActive(2).then((bactive) => {  
        var active = bactive.toNumber();
        if(this.mySeat === 3 && active === 2) {
          this.setState({seat3: 'nobus/flipside.png'});
        } else if(active === 2) {
          this.state.deckInstance.getCard(2).then((result) => this.setState({seat3: 'nobus/' + result + '.png' }));
        } else {
          this.setState({seat3: 'nobus/blank.png'});
        }
      })

      this.state.deckInstance.playerActive(3).then((bactive) => { 
        var active = bactive.toNumber(); 
        if(this.mySeat === 4 && active === 2) {
          this.setState({seat4: 'nobus/flipside.png'});
        } else if(active === 2) {
          this.state.deckInstance.getCard(3).then((result) => this.setState({seat4: 'nobus/' + result + '.png' }));
        } else {
          this.setState({seat4: 'nobus/blank.png'});
        }
      })
    })
  }

  bet() {
    this.state.deckInstance.bet(20, this.mySeat - 1, {gas: 4000000});
  }


    

  render() {
    let img = {
      width: 100,
      height: 100
    }

    let cards = {
      width: 70,
      height: 100,
    }

    
    return (

      <div className="App">
        <nav className="navbar pure-menu pure-menu-horizontal">
            <a href="#" className="pure-menu-heading pure-menu-link">Truffle Box</a>
        </nav>

        <main className="container">
          <div className="pure-g">
            <div className="pure-u-1-1">
              <h1>Offsuit</h1>
              <p>GameRoom : Easak's home game</p>

              <img style={cards} src={this.state.seat1}/>
              <img style={cards} src={this.state.seat2} />
              <img style={cards} src={this.state.seat3}/>
              <img style={cards} src={this.state.seat4} />

              <br/>
              
              <button onClick={this.bet}>BET!</button>
              <button onClick={this.shuffle}>SHUFFLE! </button>
              <button onClick={this.deal}>DEAL! </button>
              <button onClick={this.winner}>Calc Winner! </button> 
              
            
              <p> Winner: </p>
              <img style={cards} src={this.state.myCard}/>
              <p>One: {this.state.stack[0]}, Two: {this.state.stack[1]}, Three: {this.state.stack[2]}, Four: {this.state.stack[3]}</p>
              <button onClick={() => this.takeSeat(0)}>Seat 1</button> 
              <button onClick={() => this.takeSeat(1)}>Seat 2</button>
              <button onClick={() => this.takeSeat(2)}>Seat 3</button> 
              <button onClick={() => this.takeSeat(3)}>Seat 4</button>
              <button onClick={() => this.takeSeat(-1)}>Stand Up</button>
            </div>
              
          </div>
        </main>
      </div>
    );
  }
}

export default App
