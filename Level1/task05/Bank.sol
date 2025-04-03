// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 所有人都可以存钱
// 只有合约 owner 才可以取钱
// 只要取钱，合约就销毁掉 selfdestruct
// 扩展：支持主币以外的资产
// ERC20
// ERC721
  
contract Bank {
  address private owner;

  event Deposit(address spender, uint256 amount);
  event Transfer(address recipient, uint256 amount);

  constructor(address _owner) {
    owner = _owner;
  }

  receive() external payable {
    emit Deposit(msg.sender, msg.value);
  }

  fallback() external payable {
    emit Deposit(msg.sender, msg.value);
  }

  function getBalance() public view returns(uint256) {
    return address(this).balance;
  }

  function deposit() public payable {
    emit Deposit(msg.sender, msg.value);
  }

  function withDraw(uint amount) public payable onlyOwner {
    require(address(this).balance >= amount, "Insufficient contract balance");
    require(amount > 0, "Transaction amount must be greater than zero");
    (bool success, ) = payable(msg.sender).call{value: amount}("");
    require(success, "Transaction failed");
    emit Transfer(msg.sender, amount);
  }

  modifier onlyOwner {
    require(msg.sender == owner, " Only owner can call this function");
    _;
  }
}