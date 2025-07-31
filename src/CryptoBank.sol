// License
// SPDX-License-Identifier: MIT

// Version Solidity
pragma solidity 0.8.28;

// Functions:
    // 1. Deposit ether
    // 2. Withdraw ether

// Rules:
    // 1. Mulltiuser
    // 2. Only can deposit ether
    // 3. User can only withdraw previously deposited ether

contract CryptoBank {

    // Variables
    address public admin;
    mapping(address => uint256) public balances;


    // Events
    event DepositEtherEvent(uint256 value_, address account_);
    event WithdrawEtherEvent(uint256 value_, address account_);
    event BalanceOf(uint256 value_, address account_);

    // Modifiers
    modifier OnlyOwnerAndAdmin(address account_) {
        require (account_ == msg.sender || msg.sender == admin, "Only owner and admin can see balance");
        _;
    }
    // Constructor
    constructor(address admin_) {
        admin = admin_;
    }


    // Functions

    // Deposit ethers
    function depositEther() external payable {
        balances[msg.sender] += msg.value; 

        emit DepositEtherEvent(msg.value, msg.sender);
    }

    // Withdraw ethers
    function withdrawEther(uint256 amount_) external {
        require(amount_ <= balances[msg.sender], "Insufficient balance");

        // Update balance
        balances[msg.sender] -= amount_;

        // Sende ether
        (bool success,) = msg.sender.call{value: amount_}("");
        require(success, "Transaction failed");

        emit WithdrawEtherEvent(amount_, msg.sender);
    }

    function balanceOf(address account_) public OnlyOwnerAndAdmin(account_) returns(uint256 userBalance_) {
        userBalance_ = balances[account_];
        emit BalanceOf(userBalance_, account_);
    } 


}