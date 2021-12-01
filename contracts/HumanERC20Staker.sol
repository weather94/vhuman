pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./HumanERC20.sol";
import "./SHumanERC20.sol";

contract HumanERC20Staker is Ownable {

  HumanERC20 human;
  SHumanERC20 shuman;
  mapping (address => uint) stakes;

  function setHumanERC20 (address _address) public onlyOwner {
    human = HumanERC20(_address);
  }
  
  function setSHumanERC20 (address _address) public onlyOwner {
    shuman = SHumanERC20(_address);
  }

  function stake(uint balance) public {
    address thisContract = address(this);
    human.transferFrom(msg.sender, thisContract, balance);
    stakes[msg.sender] += balance;
    uint mintBalance = balance/human.balanceOf(thisContract)*shuman.totalSupply();
    shuman.mint(msg.sender, mintBalance);
  }

  function unstake(uint balance) public {
    address thisContract = address(this);
    shuman.transferFrom(msg.sender, thisContract, balance);
    uint returnBalance = human.balanceOf(thisContract)*balance/shuman.totalSupply();
    shuman.burn(balance);
    human.transfer(msg.sender, returnBalance);
  }
} 