// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
  
contract EnumExample {
  uint256 private status;
  address owner;

  enum Status {
    Pending,
    Shipped,
    Accepted,
    Rejected,
    Canceled,
  }

  constructor(uint256 _status) {
    status = _status;
    owner = msg.sender;
  }

  function setStatus(uint256 _status) public onlyOwner {
    status = _status;
  }

  function getStatus() external view restuns(Status) {
    return status;
  }

  modifier onlyOwner {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }
}