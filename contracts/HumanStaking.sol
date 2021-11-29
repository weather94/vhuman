pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

contract HumanStaking is Ownable {

  event Stake(uint _tokenId);
  event Unstake(uint _tokenId);

  struct StakingOption {
    uint fee;
    uint price;
    bool isManual;
    bool isStake;
  }

  mapping (uint => StakingOption) public stakes;
  IERC721Enumerable humanContract;

  constructor (address _humanContract) {
    humanContract = IERC721Enumerable(_humanContract);
  }

  modifier onlyHumanOwner(uint _tokenId) {
    require(msg.sender == humanContract.ownerOf(_tokenId));
    _;
  }

  function stake(uint _tokenId, uint fee, uint price, bool manual) public onlyHumanOwner(_tokenId) {
    // 에러처리 안해도되나?
    humanContract.safeTransferFrom(msg.sender, address(this), _tokenId);
    stakes[_tokenId] = StakingOption(fee, price, manual, true);
    emit Stake(_tokenId);
  }

  function unstake(uint _tokenId) public onlyHumanOwner(_tokenId) {
    delete stakes[_tokenId];
    humanContract.safeTransferFrom(address(this), msg.sender, _tokenId);
    emit Unstake(_tokenId);
  }
}