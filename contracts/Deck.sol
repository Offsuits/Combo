pragma solidity ^0.4.2;

contract Deck {

	mapping (uint => Card) deck;
    mapping (uint => Player) players;
    Game game;
    event SendStack(int chips, uint seat);
    event Deal();


    struct Card {
        string card;
        uint rank;
    }

    struct Player {
        Card card;
        int8 active;
        int chips;
        int currentBet;
    }

    struct Game {
        int pot;
        uint action;
        uint raiser;
        uint dealer;
        int amountToCall;
    }

    function sitDown(uint seat, int chips) {
        players[seat].active = 2;
        players[seat].chips = chips;
        SendStack(players[seat].chips, seat);
    }

    function standUp(uint seat) {
        players[seat].active = 0;
        players[seat].chips = 0;
        SendStack(players[seat].chips, seat);
    }

    function playerActive(uint seat) constant returns(int8) {
        return players[seat].active;
    }

    function initGame() {
        game.pot = 0;

        if(game.dealer == 3){
            game.action = 1; 
            game.dealer = 0;
        } else {
            game.dealer++;

            if(game.dealer == 3) {
                game.action = 0;
            } else {
                game.action = game.dealer + 1;
            }
        }

        while(players[game.action].active != 2) {
            if(game.action == 3){
                game.action = 0; 
            } else {
                game.action++;
            }
         
        }
    }

    function deal() {
        Deal();
    }

    function nextToAction() {

    }

	function calcWinner() constant returns(string) {
        uint seat = winner();
        players[seat].chips += game.pot;
        game.pot = 0;
        SendStack(players[seat].chips, seat);

        return players[seat].card.card;
	}

	function winner() returns(uint) {
		uint winner;
        uint score = 52;
        for(var i = 0; i < 4; i++) {
            if(players[i].active == 2 && players[i].card.rank < score) {
                winner = i;
                score = players[i].card.rank;
            }
        }

        return winner;
	}

    

    function bet(int amount, uint seat) {
        players[seat].chips = players[seat].chips - amount;
        players[seat].currentBet += amount;
        game.pot += amount;
        game.amountToCall = players[seat].currentBet;
        SendStack(players[seat].chips, seat);
    }

	function getCard(uint index) constant returns(string) {
		return players[index].card.card;
	}

    function shuffle() {
        Card memory temp;
        uint randCard;

        for(uint i = 52; i > 0; i--) {
            randCard = rand(i);
            temp = deck[i - 1];
            deck[i - 1] = deck[randCard];
            deck[randCard] = temp;
        }

        for(i = 0; i < 4; i++) {
            players[i].card = deck[i];
        }
    }


	function Deck() {
		string[] memory suits = new string[](4);
		suits[0] = 's';
		suits[1] = 'h';
		suits[2] = 'c';
		suits[3] = 'd';

		string[] memory faces = new string[](13);
		faces[0] = 'A';
		faces[1] = 'K';
		faces[2] = 'Q';
		faces[3] = 'J';
		faces[4] = 'T';
		faces[5] = '9';
		faces[6] = '8';
		faces[7] = '7';
		faces[8] = '6';
		faces[9] = '5';
		faces[10] = '4';
		faces[11] = '3';
		faces[12] = '2';

		
		uint8 deckPosition = 0;

		for(uint8 i = 0; i < faces.length; i++) {
			for(uint j = 0; j < suits.length; j++) {
                deck[deckPosition].card = strConcat(faces[i], suits[j]);
                deck[deckPosition].rank = deckPosition;
				deckPosition++;
			}
		}


        uint index = 0;

        while(index < 4) {
            players[index].active = 0;
            index++;
        }

          game.dealer = 0;
	}

	function rand(uint max) returns(uint) {
		return uint(block.blockhash(block.number-1)) % max + 1;
	}

	function strConcat(string _a, string _b) internal returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);

        string memory abcde = new string(_ba.length + _bb.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;

        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
     
        return string(babcde);
	}

	function UintToString(uint v) constant returns (string) {
      bytes32 ret;
      if (v == 0) {
        ret = '0';
      }
      else {
	      while (v > 0) {
          ret = bytes32(uint(ret) / (2 ** 8));
          ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
          v /= 10;
	      }
      }

      bytes memory bytesString = new bytes(32);

      for (uint j=0; j<32; j++) {
        byte char = byte(bytes32(uint(ret) * 2 ** (8 * j)));
        if (char != 0) {
          bytesString[j] = char;
        }
      }

      return string(bytesString);
	}

	// function str2Bytes32(string memory source) returns (bytes32 result) {
 //    assembly {
 //        result := mload(add(source, 32))
 //    }
	// }

}