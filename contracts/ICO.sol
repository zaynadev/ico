//SPDX-License-Identifier: MIT

pragma solidity 0.8.17;
import "./Token.sol";

contract ICO is Token{

    address public admin;
    address payable public deposit; 
    uint public constant tokenPrice = 0.001 ether; // token price
    uint public raisedAmount;
    uint public constant maxCap = 300 ether;
    uint public saleStart = block.timestamp;
    uint public saleEnd = block.timestamp + 604800; // ico ends after 1 week
    uint public tradeStart = saleEnd + 604800; // lock tokens for one week
    uint public constant maxInvest = 5 ether;
    uint public constant minInvest = 0.01 ether;
    enum State { beforeStart, running, afterEnd, halted }
    State public icoState; 

    constructor(address payable _deposit){
        deposit = _deposit;
        admin = msg.sender;
        icoState = State.beforeStart;
    }

}