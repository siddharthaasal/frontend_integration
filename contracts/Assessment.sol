// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Assessment {

    struct Transaction {
        uint256 timestamp;
        uint256 amount;
        bool isDeposit;
    }

    mapping(address => Transaction[]) public transactionHistory;
    address payable public owner;
    uint256 public balance;
    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);

    constructor(uint initBalance) payable {
        owner = payable(msg.sender);
        balance = initBalance;
    }

    function getBalance() public view returns (uint256) {
        return balance;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function deposit(uint256 _amount) public payable {
        uint _previousBalance = balance;
        require(msg.sender == owner, "You are not the owner of this account");
        balance += _amount;
        assert(balance == _previousBalance + _amount);
        transactionHistory[msg.sender].push(Transaction(block.timestamp, _amount, true));
        emit Deposit(_amount);
    }

    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function withdraw(uint256 _withdrawAmount) public {
        require(msg.sender == owner, "You are not the owner of this account");
        uint _previousBalance = balance;
        if (balance < _withdrawAmount) {
            revert InsufficientBalance({
                balance: balance,
                withdrawAmount: _withdrawAmount
            });
        }
        balance -= _withdrawAmount;
        assert(balance == (_previousBalance - _withdrawAmount));
        transactionHistory[msg.sender].push(Transaction(block.timestamp, _withdrawAmount, false));
        emit Withdraw(_withdrawAmount);
    }

    function getTransactionHistory() public view returns (Transaction[] memory) {
    return transactionHistory[msg.sender];
}
}

