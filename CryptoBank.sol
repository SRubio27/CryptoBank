// Licencia
// SPDX-License_Identifier: GPL-3.0

// Version Solidity
pragma solidity 0.8.30;

// Functions:
    // 1. Deposit ether
    // 2. Withdraw ether

// Rules:
    // 1. Mulltiuser
    // 2. Only can deposit ether
    // 3. User can only withdraw previously deposited ether

contract CryptBank {
    
    address public owner;
    uint256 public maxBalance;
    mapping(address => uint256) public balances;
    
    // Events
    event Deposit(address user_, uint256 amount_);
    event Withdraw(address user_, uint256 amount_);

    // Modifiers
    modifier onlyOwner(){
        require(msg.sender != owner, "Only owner can call this function");
        _;
    }

    // Constructor
    constructor(uint256 maxBalance_) {
        owner = msg.sender;
        maxBalance = maxBalance_;
    }

    // Functions

    // 1. Deposit
    function deposit() external payable {
        require(msg.value > 0, "You must deposit ether");
        require(balances[msg.sender] + msg.value <= maxBalance, "You have reached the maximum balance");
        
        // Update the balance
        balances[msg.sender] += msg.value;

        // Emit the event
        emit Deposit(msg.sender, msg.value);
    }

    // 2. Withdraw
    function withdraw(uint256 amount_) external {
        require(amount_ > 0, "You must withdraw ether");
        require(balances[msg.sender] >= amount_, "Not enough ether");
        
        // Update the balance
        balances[msg.sender] -= amount_;
        
        // Send the ether
        (bool success, ) = msg.sender.call{value: amount_}("");
        require(success, "Transaction failed");

        // Emit the event
        emit Withdraw(msg.sender, amount_);
    }

    // 3. Change maxBalance
    function newMaxBalance(uint256 newMaxBalance_) public onlyOwner {
        maxBalance = newMaxBalance_;
    }




}
