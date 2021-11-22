pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ERC721Tradable.sol";

contract Human is ERC721Tradable {
  

  constructor(address _proxyRegistryAddress)
      ERC721Tradable("Human", "HUM", _proxyRegistryAddress)
  {}


  function baseTokenURI() override public pure returns (string memory) {
    return "";
  }
    // function baseTokenURI() override public pure returns (string memory) {
    //     return "https://creatures-api.opensea.io/api/creature/";
    // }

}