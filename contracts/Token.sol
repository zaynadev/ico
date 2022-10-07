//SPDX-License-Identifier: MIT

pragma solidity 0.8.17;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20{
    address public founder;

    constructor() ERC20("MyToken", "TKN"){
        founder = msg.sender;
        _mint(founder, 1000000);
    }
}