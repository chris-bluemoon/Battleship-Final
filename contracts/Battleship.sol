pragma solidity ^0.4.24;

import "./SafeMath.sol";

/// @title Battleship game
/// @author Chris Milner
contract Battleship {
  using SafeMath for uint256;

  enum GameState {InPlay, PlacingShips, GameEnded}

  uint constant BOARDSIZE = 10;

  bool private stopped = false;
  address private owner;

 struct ship {
      string shipName;
      uint shipLength;
      uint shipCode;
      uint shipStatus;
      uint shipDamage;
  }

  struct playerState {
      string playerName;
      address playerAddr;
      uint[BOARDSIZE][BOARDSIZE] boardMatrix;
      bool isActive;
      ship[] ships;
  }

  playerState player1;
  playerState player2;

  ship frigate;
  ship submarine;
  ship destroyer;

  GameState gameState;

  playerState currentPlayer;

  string shotResult;

  uint constant MISS = 8;
  uint constant HIT = 9;

  uint constant SHIP_FREE = 0;
  uint constant SHIP_PLACED = 1;
  uint constant SHIP_SUNK = 2;

  uint constant HORIZONTAL = 0;
  uint constant VERTICAL = 1;

  uint constant NUM_OF_SHIPS = 3;

   constructor() public {
    gameState = GameState.GameEnded;

    frigate.shipName = "FRIGATE";
    frigate.shipLength = 1;
    frigate.shipCode = frigate.shipLength;
    frigate.shipStatus = SHIP_FREE;
    submarine.shipName = "SUBMARINE";
    submarine.shipLength = 2;
    submarine.shipCode = submarine.shipLength;
    submarine.shipStatus = SHIP_FREE;
    destroyer.shipName = "DESTROYER";
    destroyer.shipLength = 3;
    destroyer.shipCode = destroyer.shipLength;
    destroyer.shipStatus = SHIP_FREE;

    player1.ships.push(frigate);
    player1.ships.push(submarine);
    player1.ships.push(destroyer);
    player2.ships.push(frigate);
    player2.ships.push(submarine);
    player2.ships.push(destroyer);

  }

  event LogShotResult(string, string);
  event LogPlaceLegality(string, string);
  event LogShipStartStop(uint,uint);
  event LogAllShipsPlaced(string);
  event LogShipPlaced(string,uint,uint,uint);
  event LogCurrentShip(string,string,uint);
  event LogShipSunk(string,string,string);
  event LogGameWon(string,string);
  event LogAllShipsSunk(string,string);
  event LogCheckShipStatus(string,string,uint);

  modifier isAdmin() {
    if(msg.sender != owner) {
        revert();
    }
    _;
  }

  modifier stopInEmergency { if (!stopped) _; }

  modifier onlyInEmergency { if (stopped) _; }

  modifier isGameInPlay {
    require(gameState == GameState.InPlay);
    _;
  }

 modifier hasGameEnded {
    require(gameState == GameState.GameEnded);
    _;
  }

  modifier playersRegistered {
      require(gameState == GameState.PlacingShips);
      _;
  }

  /// @notice Returns the names of the players registered
  /// @dev This is more for testing purposes but would have been used in the
  /// complete version of the game.
  /// @return Returns two strings holding each player name.
  function returnPlayers() constant public returns (string,string) {
    return (player1.playerName, player2.playerName);
  }

  /// @notice Toggles our circuit breaker boolean
  function toggleContractActive() isAdmin public
  {
    stopped = !stopped;
  }

  /// @notice Registers the players name and addresses
  /// @dev The address was captured but not used in this limited form
  /// of the game. Future use would be to have the address listed in the
  /// lobby which has yet to be implemented.
  /// @param playerName the name of the player.
  function registerPlayer(string playerName) public {

    bytes memory tempEmptyStringTest = bytes(player1.playerName);

    if (tempEmptyStringTest.length == 0) {
      player1.playerAddr = msg.sender;
      player1.playerName = playerName;
      currentPlayer = player1;
    } else {
      player2.playerAddr = msg.sender;
      player2.playerName = playerName;
      gameState = GameState.PlacingShips;
    }
  }

  /// @notice Places a ship during the set up of the game
  /// @dev Players must have registered before they can place a ship
  /// @param x is x coordindate, y is the y coordinate to start the placement, shipType is
  /// the type of ship being placed, playerName is the name of the player
  /// placing and direction is 0 or 1 (horizontal or vertical)
  function placeShip(uint x, uint y, string shipType, string playerName, uint direction) public playersRegistered {

      ship memory currentShip = ship("", 0, 0, 0, 0);

      playerState memory placingPlayer;

      if (compareStrings(playerName, player1.playerName)) {
          placingPlayer = player1;
      } else {
          placingPlayer = player2;
      }

      if (compareStrings(shipType, frigate.shipName)) {
          currentShip = placingPlayer.ships[0];
      } else if (compareStrings(shipType, submarine.shipName)) {
          currentShip = placingPlayer.ships[1];
        } else if (compareStrings(shipType, destroyer.shipName)) {
              currentShip = placingPlayer.ships[2];
          }

      emit LogCurrentShip("Current ship is",currentShip.shipName, currentShip.shipCode);

      uint startSquareX = x;
      uint endSquareX = x.add(currentShip.shipLength);
      uint startSquareY = y;
      uint endSquareY = y.add(currentShip.shipLength);

      require(x >= 0 && y >= 0);
      require(endSquareX < BOARDSIZE && endSquareY < BOARDSIZE);
      require(currentShip.shipStatus == SHIP_FREE);

      if (direction == HORIZONTAL) {
          for (uint i=startSquareX; i<endSquareX; i.add(1)) {
              require(currentPlayer.boardMatrix[i][y] == 0);
              placingPlayer.boardMatrix[i][y] = currentShip.shipCode;
              currentShip.shipStatus = SHIP_PLACED;
              emit LogShipPlaced("Ship placed at location",i,y,currentShip.shipCode);
            }
          } else {
            for (i=startSquareY; i<endSquareY; i.add(1)) {
              require(currentPlayer.boardMatrix[x][i] == 0);
              placingPlayer.boardMatrix[x][i] = currentShip.shipCode;
              currentShip.shipStatus = SHIP_PLACED;
            }
      }

      bool allShipsPlaced = true;

      for (i=0; i<player1.ships.length; i.add(1)) {
          if (player1.ships[i].shipStatus == SHIP_FREE) {
            allShipsPlaced = false;
          }
      }
      for (i=0; i<player2.ships.length; i.add(1)) {
        if (player2.ships[i].shipStatus == SHIP_FREE) {
          allShipsPlaced = false;
        }
      }
      if (allShipsPlaced == true) {
          emit LogAllShipsPlaced("All Ships Placed");
          gameState = GameState.InPlay;
      }
  }

  /// @notice Sets the state variable currentPlayer to the player
  /// whos turn it is
  /// @dev This should be reviewed in future as it may be unsafe to assign
  /// temporary state variables in this way (by copy). The code works so
  /// keeping with this for now.
  function switchCurrentPlayer() internal {
      if (compareStrings(currentPlayer.playerName, player1.playerName)) {
          currentPlayer = player2;
      } else {
          currentPlayer = player1;
      }
  }

  /// @notice Called from fireShot and checks if a player has sunk all
  /// opponents ships.
  /// @dev Loops through the opponents ships array and checks for each
  /// shipStatus
  /// @param playerName_ holds the name of the player we are checking
  /// @return true if all ships are SHIP_SUNK
  function checkIfWon(string playerName_) private returns (bool) {

      bool allShipsSunk = true;

      if (compareStrings(playerName_, player1.playerName)) {
          for (uint i=0; i<NUM_OF_SHIPS; i.add(1)) {
            emit LogCheckShipStatus(playerName_,player2.ships[i].shipName,player2.ships[i].shipStatus);
            if (player2.ships[i].shipStatus != SHIP_SUNK) {
              allShipsSunk = false;
            }
           }
      }
      if (compareStrings(playerName_, player2.playerName)) {
          for (i=0; i<NUM_OF_SHIPS; i.add(1)) {
            emit LogCheckShipStatus(playerName_,player1.ships[i].shipName,player1.ships[i].shipStatus);
            if (player1.ships[i].shipStatus != SHIP_SUNK) {
              allShipsSunk = false;
            }
           }
      }
      if (allShipsSunk == true) {
          emit LogAllShipsSunk("All ships sunk for", playerName_);
      }
      return allShipsSunk;
  }

  /// @notice Fires a shot
  /// @dev We use currentPlayer to automatically get the current player
  /// who's turn it is and after a shot is fired, switchCurrentPlayer is called.
  /// @param x is the x coordinate of the guess, y is the y coordinate of the guess
  /// @return shotResult, HIT or MISS string
  function fireShot(uint x, uint y) isGameInPlay public returns (string) {
      if (compareStrings(currentPlayer.playerName, player1.playerName)) {
          if (player2.boardMatrix[x][y] >= 1 && player2.boardMatrix[x][y] <= 5) {
              shotResult = "HIT";
              uint player2ShipType = player2.boardMatrix[x][y];

              player2.boardMatrix[x][y] = HIT;
              player2.ships[player2ShipType-1].shipDamage.add(1);
              if (player2.ships[player2ShipType-1].shipDamage == player2ShipType) {
                  player2.ships[player2ShipType-1].shipStatus = SHIP_SUNK;
                  emit LogShipSunk(player2.playerName, player2.ships[player2ShipType-1].shipName, "SUNK");
              }

              emit LogShotResult(shotResult,currentPlayer.playerName);
              if (checkIfWon(currentPlayer.playerName)) {
                  gameState = GameState.GameEnded;
                  emit LogGameWon("Game Won!",currentPlayer.playerName);
              }
              switchCurrentPlayer();
              return (shotResult);
          } else {
              shotResult = "MISS";
              player2.boardMatrix[x][y] = MISS;
              emit LogShotResult(shotResult,currentPlayer.playerName);

              switchCurrentPlayer();
              return (shotResult);
          }
      } else {
          if (player1.boardMatrix[x][y] >= 1 && player1.boardMatrix[x][y] <= 5) {
              shotResult = "HIT";
              uint player1ShipType = player1.boardMatrix[x][y];

              player1.boardMatrix[x][y] = HIT;
              player1.ships[player1ShipType-1].shipDamage.add(1);
              if (player1.ships[player1ShipType-1].shipDamage == player1ShipType) {
                  player1.ships[player1ShipType-1].shipStatus = SHIP_SUNK;
                  emit LogShipSunk(player1.playerName, player1.ships[player1ShipType-1].shipName, "SUNK");
              }
              emit LogShotResult(shotResult,currentPlayer.playerName);
              if (checkIfWon(currentPlayer.playerName)) {
                  gameState = GameState.GameEnded;
                  emit LogGameWon("Game Won!", currentPlayer.playerName);
              }
              switchCurrentPlayer();
              return shotResult;
          } else {
              shotResult = 'MISS';
              player1.boardMatrix[x][y] = MISS;
              emit LogShotResult(shotResult,currentPlayer.playerName);
              switchCurrentPlayer();
              return shotResult;
          }
      }
  }

  /// @notice Function to compare two strings
  /// @dev This was copied from a source on the internet as no built-in
  /// functions currently exist to compare strings
  /// @param a first string, b second string
  /// @return true is strings are identical
  function compareStrings (string a, string b) private pure returns (bool) {
       return keccak256(a) == keccak256(b);
  }

}
