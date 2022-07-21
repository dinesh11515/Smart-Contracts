//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract EtherWallet {

    address payable public owner;

    event Deposit(address indexed account, uint amount);
    event Withdraw(address indexed account, uint amount);

    constructor(){
        owner = payable(msg.sender);
    }

    modifier onlyOwner(){
        require(owner == msg.sender);
        _;
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function withdraw(uint amount) public onlyOwner {
        owner.transfer(amount);
        emit Withdraw(owner,amount);
    }


    receive() external payable{
        emit Deposit(msg.sender,msg.value);
    }
    fallback() external payable{}
}

