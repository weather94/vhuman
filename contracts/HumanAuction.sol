pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HumanAuction is Ownable {

  event AddBid(uint tokenId, Bid bid);
  event Execute(uint tokenId);
  event AddAuction(uint tokenId, Auction auction);

  struct Auction {
    Bid lastBid;
    uint deadline;
    bool executed;
  }

  struct Bid {
    address bidder;
    uint balance;
    uint time;
  }

  mapping(uint => Auction) public auctions;
  mapping(uint => Bid[]) public bids;

  ERC721 humanERC721;
  ERC20 humanERC20;

  constructor () {}

  function setHumanERC721(address _address) public onlyOwner {
    humanERC721 = ERC721(_address);
  }

  function setHumanERC20(address _address) public onlyOwner {
    humanERC20 = ERC20(_address);
  }

  modifier onlyHumanOwner(uint _tokenId) {
    require(msg.sender == humanERC721.ownerOf(_tokenId));
    _;
  }

  function transferERC20(address _to, uint _balance) public onlyOwner {
    humanERC20.transfer(_to, _balance);
  }

  function addAuction(uint _tokenId, uint deadline) public onlyOwner returns (uint) {
    // deadline이 현재시간보다 더 뒤인지 확인 require
    humanERC721.transferFrom(msg.sender, address(this), _tokenId);
    auctions[_tokenId] = Auction(Bid(msg.sender, 0, block.timestamp), deadline, false);
    emit AddAuction(_tokenId, auctions[_tokenId]);
    return _tokenId;
  }

  function bid(uint _tokenId, uint _balance) public {
    Auction storage auction = auctions[_tokenId];
    uint current = block.timestamp;
    require(auction.deadline > current);
    require(auction.lastBid.balance < _balance);
    humanERC20.transferFrom(msg.sender, address(this), _balance);
    humanERC20.transfer(auction.lastBid.bidder, auction.lastBid.balance); // 금액반환
    bids[_tokenId].push(auction.lastBid);
    auction.lastBid = Bid(msg.sender, _balance, current);
    emit AddBid(_tokenId, auction.lastBid);
  }

  function execute(uint _tokenId) public {
    Auction storage auction = auctions[_tokenId];
    uint current = block.timestamp;
    require(auction.executed == false, "");
    require(auction.deadline < current, "");
    humanERC721.safeTransferFrom(address(this), auction.lastBid.bidder, _tokenId);
    auction.executed = true;
    emit Execute(_tokenId);
  }
}