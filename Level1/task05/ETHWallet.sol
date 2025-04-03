// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
  
contract ETHWallet {
  address owner;

  constructor(address _owner) {
    owner = _owner;
  }

  function transfer() external payable onlyOwner {
    payable(msg.sender).transfer(200);
  }

  function send() external payable onlyOwner {
    (bool success) = payable(msg.sender).send(200);
    require(success, "Transaction failed");
  }

  function call() external payable onlyOwner {
    (bool success, ) = payable(msg.sender).call{value: 200}("");
    require(success, "Transaction failed");
  }

  modifier onlyOwner {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }
}