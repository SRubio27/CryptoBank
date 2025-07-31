// Licencia
// SPDX-License-Identifier: MIT

// Version Solidity
pragma solidity 0.8.28;

import "../src/CryptoBank.sol";
import "forge-std/test.sol";

contract CryptoBankTest is Test {

    CryptoBank cryptoBank;
    address public admin = vm.addr(1);
    address public randomUser = vm.addr(2);

    // setUp
    function setUp() public {
        cryptoBank = new CryptoBank(admin);
    }


    // Unit testing

    function testDepositEther() public {
        vm.startPrank(admin);
        cryptoBank.depositEther();

        vm.stopPrank();
    }


    function testWithdrawEtherCorrectly() public {

        vm.deal(admin, 5 ether);
        vm.startPrank(admin);
        cryptoBank.depositEther{value: 5 ether}();
        cryptoBank.withdrawEther(1 ether);

        // Address balance
        assertEq(admin.balance, 1 ether);

        // CryptoBank address balance
        
        assertEq(cryptoBank.balanceOf(admin), 4 ether);

        vm.stopPrank();
    }

    function testWithdrawInsufficientBalance() public {
        vm.deal(randomUser, 1 ether);

        vm.startPrank(randomUser);
        vm.expectRevert();

        cryptoBank.withdrawEther(1 ether);

        vm.stopPrank();
    }




    // Fuzzing testing


    function testRandomUserCanNotViewBalanceOfOtherAddress(address account_) public {
        vm.startPrank(randomUser);
        vm.expectRevert();

        cryptoBank.balanceOf(account_);

        
        vm.stopPrank();
    }
    function testAdminCanViewAllBalances(address account_) public {
        vm.startPrank(admin);
        cryptoBank.balanceOf(account_);

        vm.stopPrank();
    }

    function testBalanceOf(address account_) public {
        vm.startPrank(account_);
        cryptoBank.balanceOf(account_);

        vm.stopPrank();
    }

    




}

