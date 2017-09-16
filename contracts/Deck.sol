pragma solidity ^0.4.2;

contract Deck {

	mapping (uint => Card) deck;
    mapping (uint => Player) players;
	uint current = 0;


    struct Card {
        string card;
        uint rank;
    }

    struct Player {
        Card card;
        bool active;
        uint chips;
        //uint seat;
    }

    function sitDown(uint seat, uint chips) {
        players[seat].active = true;
        players[seat].chips = chips;
    }

    function standUp(uint seat) {
        players[seat].active = false;
    }

    function playerActive(uint seat) constant returns(bool) {
        return players[seat].active;
    }

	function calcWinner() constant returns(string) {
        uint seat = winner();

        return players[seat].card.card;
	}

	function incrementCurrent() {
		current++;
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

		current = 0;

        for(i = 0; i < 4; i++) {
            players[i].card = deck[i];
        }
	}

	function winner() returns(uint) {
		uint winner;
        uint score = 52;
        for(var i = 0; i < 4; i++) {
            if(players[i].active && players[i].card.rank < score) {
                winner = i;
                score = players[i].card.rank;
            }
        }

        return winner;
	}

	function getCard(uint index) constant returns(string) {
		return players[index].card.card;
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
            players[index].active = false;
            index++;
        }
	}

	function rand(uint max) returns(uint) {
		return uint(block.blockhash(block.number-1))%max + 1;
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

	function values(string card) returns(uint){
		uint value;

	}
}



