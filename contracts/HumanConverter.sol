pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./HumanStaker.sol";
import "./HumanERC20.sol";

// 수수료와 관련된 코드도 넣어야됨.
contract HumanConverter is HumanStaker {


  event AddConverter();
  event AddRequest();

  enum STATUS { WAIT, CONVERT, SUCCESS, CANCEL, ERROR, COMPLAIN, END }

  struct Request {
    address client;
    address converter;
    string sourceUri;
    string humanNumber;
    string resultUri;
    STATUS status;
    uint tokenId;
    uint result;
    uint date;
  }

  struct Converter {
    uint total;
    uint balance;
    uint convertCount;
    uint complainCount;
  }

  uint converterFee;
  address humanERC20StakerAddress;
  mapping (address => Converter) public converter;
  Request[] public requests;

  constructor () {}

  modifier onlyConverter() {
    require(converter[msg.sender].total >= 0);
    _;
  }

  modifier onlyConverterOf(uint _requestId) {
    require(requests[_requestId].converter == msg.sender);
    _;
  }

  function addConverter() public {
    require(converter[msg.sender].total < 1, "already converter!");
    humanERC20.transferFrom(msg.sender, humanERC20StakerAddress, converterFee);
    converter[msg.sender] = Converter(1, 0, 0, 0);
  }

  function setHumanERC20Staker(address _address) public onlyOwner {
    humanERC20StakerAddress = _address;
  } 

  function setConverterFee(uint _balance) public onlyOwner {
    converterFee = _balance;
  }

  function request(string memory _sourceUri, address _converter, string memory _humanNumber, uint _tokenId) public {
    // stakes[_tokenId];
    // 스테이킹중이거나, 본인 소유인지 확인
    requests.push(Request(msg.sender, _converter, _sourceUri, "", _humanNumber, STATUS.WAIT, _tokenId, 0, 0));
  }

  function start(uint _requestId) public onlyConverter {
    Request storage _request = requests[_requestId];
    require(_request.status == STATUS.WAIT);
    require(_request.converter == address(0) || _request.converter == msg.sender);
    
    _request.status = STATUS.CONVERT;
    _request.converter = msg.sender;
  }

  function success(uint _requestId, string memory _resultUri) public {
    Request storage _request = requests[_requestId];
    require(_request.converter == msg.sender);

    _request.status = STATUS.SUCCESS;
    _request.resultUri = _resultUri;
    _request.date = block.timestamp;
  }

  function confirm(uint _requestId) public {
    Request storage _request = requests[_requestId];
    converter[_request.converter].convertCount += 1;
    _request.status = STATUS.END;
  }

  function complain(uint _requsetId) public {
    Request storage _request = requests[_requsetId];
    converter[_request.converter].complainCount += 1;
  }
}