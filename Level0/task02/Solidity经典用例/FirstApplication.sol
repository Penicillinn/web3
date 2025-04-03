// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
    
contract Counter {
  uint public counter;

  // Function to get the current count
  function getConter() public view returns (uint) {
    return counter;
  }

  // Function to increment count by 1
  function increment() public {
    counter += 1;
  }

  // Function to decrement count by 1
  function decrement() public {
    counter -= 1;
  }

}