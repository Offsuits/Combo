pragma solidity ^0.4.2;

//import "usingOraclize.sol"
//is usingOraclize
contract SimpleStorage {
    uint storedData;
  // bytes32 user;
  // user = "Easak";
  // var age = 9;
  // var info = []; 
   string name;
   string cards;
    uint counter;
    address owner;
    address creator;

// modifier onlyOwner() {
//     if (msg.sender != owner) throw;
//     _;
//   }

  // function SimpleStorage(uint initData, address initOwner) {
  //   owner = initOwner;
  //   storedData = initData;
    
  //   // OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
  // }
  function SimpleStorage() {
    creator = msg.sender;
    counter = 2;
  }

  function increment(uint d) 
  {
    counter = counter + d;
  }
  
  function getCounter() constant returns (uint) 
  {
      return counter;
  }
  
  function get() constant returns (uint) {
    //storedData = storedData + 1;
    return storedData;
  }


  function set(uint x) {
    storedData = x;
  }

  // function printMe(y) {
  //   console.log(y);
  // } 
  
  // function increase(uint m) {
  //   storedData = m + 1;
  //   //counter = counter + 1;
  // }

  // function counterSet(uint x) {
  //   counter = x;
  // }

  function sendName() constant returns (uint) {
    //name = "Abhi";
    counter = counter + 1;
    return counter ;
  }

  function sendCard() constant returns(string) {
    cards = "5s5h";
    return cards;
  }

}
