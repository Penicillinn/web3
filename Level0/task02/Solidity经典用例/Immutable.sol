// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
  
contract Immutable {
  address public immutable MY_ADDRESS;
  uint public immutable AGE;

  constructor(uint age) {
    MY_ADDRESS = msg.sender;
    AGE = age;
  }
}