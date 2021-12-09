pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./HumanStaker.sol";
import "./HumanERC20.sol";

// 수수료와 관련된 코드도 넣어야됨.
contract HumanConverter is HumanStaker {

  event AddConverter(address converter);
  event RemoveConverter(address converter);
  event AddRequest(address client, address converter);
  event WithdrawConverter(address converter, uint balance);
  event ConvertStart(uint requestId, address converter);
  event ConvertSuccess(uint requestId, string resultUri);
  event ConvertConfirm(uint requestId);
  event ConvertComplain(uint requestId);
  event SetConverterFee(uint balance);

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
    bool active;
  }

  uint converterFee;
  address humanERC20StakerAddress;
  mapping (address => Converter) public converter;
  Request[] public requests;

  constructor () {}

  modifier onlyConverter() {
    require(converter[msg.sender].active == true);
    _;
  }

  modifier onlyConverterOf(uint _requestId) {
    require(requests[_requestId].converter == msg.sender);
    _;
  }

  function addConverter() public {
    require(converter[msg.sender].total < 1, "already converter!");
    humanERC20.transferFrom(msg.sender, humanERC20StakerAddress, converterFee);
    converter[msg.sender] = Converter(0, 0, 0, 0, true);
  }

  function removeConverter(address _address) public onlyOwner {
    Converter storage _converter = converter[_address];
    _converter.active = false;
  }

  function setHumanERC20Staker(address _address) public onlyOwner {
    humanERC20StakerAddress = _address;
  } 

  function setConverterFee(uint _balance) public onlyOwner {
    converterFee = _balance;
    emit SetConverterFee(_balance);
  }

  function withdrawConverter(uint _balance) public {
    require(converter[msg.sender].balance > _balance);
    converter[msg.sender].balance -= _balance;
    humanERC20.transferFrom(address(this), msg.sender, _balance);
    emit WithdrawConverter(msg.sender, _balance);
  }

  function request(string memory _sourceUri, address _converter, string memory _humanNumber, uint _tokenId) public {
    // stakes[_tokenId];
    // 스테이킹중이거나, 본인 소유인지 확인
    requests.push(Request(msg.sender, _converter, _sourceUri, "", _humanNumber, STATUS.WAIT, _tokenId, 0, 0));
    emit AddRequest(msg.sender, _converter);
  }

  function start(uint _requestId) public onlyConverter {
    Request storage _request = requests[_requestId];
    require(_request.status == STATUS.WAIT);
    require(_request.converter == address(0) || _request.converter == msg.sender);
    
    _request.status = STATUS.CONVERT;
    _request.converter = msg.sender;
    emit ConvertStart(_requestId, msg.sender);
  }

  function success(uint _requestId, string memory _resultUri) public {
    Request storage _request = requests[_requestId];
    require(_request.converter == msg.sender);

    _request.status = STATUS.SUCCESS;
    _request.resultUri = _resultUri;
    _request.date = block.timestamp;
    emit ConvertSuccess(_requestId, _resultUri);
  }

  function confirm(uint _requestId) public {
    Request storage _request = requests[_requestId];
    converter[_request.converter].convertCount += 1;
    _request.status = STATUS.END;
    emit ConvertConfirm(_requestId);
  }

  function complain(uint _requestId) public {
    Request storage _request = requests[_requestId];
    converter[_request.converter].complainCount += 1;
    emit ConvertComplain(_requestId);
  }
}