pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HumanERC20 is ERC20 {
    constructor() ERC20("HUMAN", "HUM") {
        _mint(msg.sender, 1000000000 * 10 ** decimals());
    }
}