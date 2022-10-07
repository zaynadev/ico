//SPDX-License-Identifier: MIT

pragma solidity 0.8.17;
import "./Token.sol";

contract ICO is Token{
    Token token;
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
    enum State { running, end, halted }
    State public icoState; 

    event Invest(address investor, uint value, uint tokens);

    constructor(address payable _deposit, address _token){
        deposit = _deposit;
        token = Token(_token);
        admin = msg.sender;
        icoState = State.running;
    }

    function halt() public onlyAdmin beforeEnd{
        icoState = State.halted;
    }

     function resume() public onlyAdmin beforeEnd{
        icoState = State.running;
    }

    function currentState() public view returns(State) {
        return saleEnd <= block.timestamp ? State.end : icoState ;
    }

    function changeDepositAddress(address payable _deposit) public onlyAdmin {
        deposit = _deposit;
    }

    function invest() payable public beforeEnd returns(bool){
        require(icoState == State.running, "ico is halted!");
        require(msg.value >= minInvest, "min amount is 0.01 ether!");
        require(msg.value <= maxInvest, "max amount is 5 ether!");
        require(raisedAmount <= maxCap, "wrong token amount!");

        uint tokens = msg.value / tokenPrice; 
        super._transfer(founder, msg.sender, tokens);
        deposit.transfer(msg.value);

        emit Invest(msg.sender, msg.value, tokens);
        
        return true;

    }

    receive() payable external{
        invest();
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        require(block.timestamp > tradeStart, "trade not yet started!");
        super.transfer(to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        require(block.timestamp > tradeStart, "trade not yet started!");
        super.transferFrom(from, to, amount);
        return true;
    }

    modifier beforeEnd(){
        require(saleEnd > block.timestamp, "ico ended!");
        _;
    }

    modifier onlyAdmin(){
        require(msg.sender == admin);
        _;
    }

}