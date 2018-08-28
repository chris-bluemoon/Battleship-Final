import "truffle/build/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Battleship.sol";

contract TestBattleship {

  function testRegisterPlayer() {
    Battleship battleship = new Battleship();

    string memory expected = "Joe";
 
    battleship.registerPlayer("Joe");

    Assert.equal(9, 0, “Value expected should be zero”);
  }
}
