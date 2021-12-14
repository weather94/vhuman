pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./SHumanERC721.sol";

contract HumanStaker is Ownable {

  event Stake(uint tokenId, uint fee, bool manual);
  event Unstake(uint tokenId);
  event Use(uint tokenId, address user, uint balance);
  event Withdraw(uint tokenId, uint balance);

  struct StakingOption {
    uint fee;
    uint balance;
    bool isManual;
    bool isExist;
  }

  mapping (uint => StakingOption) public stakes; 
  ERC721 humanERC721;
  SHumanERC721 shumanERC721;
  ERC20 humanERC20;

  constructor () {}

  function setHumanERC721(address _address) public onlyOwner {
    humanERC721 = ERC721(_address);
  }

  function setSHumanERC721(address _address) public onlyOwner {
    shumanERC721 = SHumanERC721(_address);
  }

  function setHumanERC20(address _address) public onlyOwner {
    humanERC20 = ERC20(_address);
  }

  modifier onlyHumanOwner(uint _tokenId) {
    require(msg.sender == humanERC721.ownerOf(_tokenId));
    _;
  }

  modifier onlySHumanOwner(uint _tokenId) {
    require(msg.sender == shumanERC721.ownerOf(_tokenId));
    _;
  }

  function stake(uint _tokenId, uint fee, bool manual) public onlyHumanOwner(_tokenId) {
    // 에러처리 안해도되나?
    humanERC721.safeTransferFrom(msg.sender, address(this), _tokenId);
    stakes[_tokenId] = StakingOption(fee, 0, manual, true);
    shumanERC721.safeMint(msg.sender, _tokenId);
    emit Stake(_tokenId, fee, manual);
  }

  function unstake(uint _tokenId) public onlySHumanOwner(_tokenId) {
    StakingOption storage option = stakes[_tokenId];
    humanERC20.transfer(msg.sender, option.balance);
    humanERC721.safeTransferFrom(address(this), msg.sender, _tokenId);
    shumanERC721.burn(_tokenId);
    delete stakes[_tokenId];
    emit Unstake(_tokenId);
  }

  function use(uint _tokenId) public {
    StakingOption storage option = stakes[_tokenId];
    humanERC20.transferFrom(msg.sender, address(this), option.fee);
    option.balance += option.fee;
    emit Use(_tokenId, msg.sender, option.fee);
  }

  function withdraw(uint _tokenId, uint _balance) public onlySHumanOwner(_tokenId) {
    StakingOption storage option = stakes[_tokenId];
    require(option.balance >= _balance);
    option.balance -= _balance;
    humanERC20.transfer(msg.sender, _balance);
    emit Withdraw(_tokenId, _balance);
  }
}