pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ERC721Tradable.sol";

contract Auction {

  struct VHuman {
    string name;
    string description;
    string hash;
  }

  VHuman[] public humans;
  

  constructor(address _proxyRegistryAddress)
      ERC721Tradable("Human", "HUM", _proxyRegistryAddress)
  {}


  function baseTokenURI() override public pure returns (string memory) {
    return "";
  }

  function mint(address to, string memory name, string memory description, string memory hash) public onlyOwner{
    mintTo(to);
    humans.push(VHuman(name, description, hash));
  }

  // function baseTokenURI() override public pure returns (string memory) {
  //     return "https://creatures-api.opensea.io/api/creature/";
  // }
}