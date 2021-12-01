pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./HumanStaker.sol";

// 수수료와 관련된 코드도 넣어야됨.
contract HumanConverter is HumanStaker {

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
    uint amount;
    uint convertCount;
    uint complainCount;
  }

  mapping (address => Converter) public converter;
  Request[] public requests;

  constructor () {}

  modifier onlyConverter() {
    require(converter[msg.sender].amount >= 0); // 이거 알아내야함 어떻게할지
    _;
  }

  modifier onlyConverterOf(uint _requestId) {
    require(requests[_requestId].converter == msg.sender);
    _;
  }

  function request(string memory _sourceUri, string memory _humanNumber, uint _tokenId) public {
    // stakes[_tokenId];
    // 스테이킹중이거나, 본인 소유인지 확인
    requests.push(Request(msg.sender, address(0), _sourceUri, "", _humanNumber, STATUS.WAIT, _tokenId, 0, 0));
  }

  function start(uint _requestId) public onlyConverter {
    Request storage _request = requests[_requestId];
    require(_request.status == STATUS.WAIT);
    
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
    // 여기서 이제 그거 시작한다. 투표 같은거 시작하기.
  }
}