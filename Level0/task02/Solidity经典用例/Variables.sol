// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
    
contract Variables {
  // state variables
  uint public state = 0;

  function test() public pure returns (uint) {
    // local variables
    uint a = 1;
    return a;
  }

  function bar() public view returns (address, uint) {
    address addr = msg.sender;
    uint256 tiamstamp = block.timestamp;
    return (addr, tiamstamp);
  }
}