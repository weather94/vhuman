pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract HumanFactory is Ownable {
  
  Human[] public humans;

  struct Human {
    string name;
    string humanhash;
    uint32 changeCount;
  }

  mapping (uint => address) public humanToOwner;
  mapping (address => uint) ownerHumanCount;

  function createHuman(string memory _name, string memory _humanhash) public onlyOwner {
    humans.push(Human(_name, _humanhash, 0));
    uint id = humans.length - 1;
    ownerHumanCount[msg.sender]++;
    humanToOwner[id] = msg.sender;
  }
}