// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
  
contract Gas {
  uint public i = 0;

  // Using up all of the gas that you send causes your transaction to fail.
  // State changes are undone.
  // Gas spent are not refunded.
  function loop() internal {
    while(true) {
      i += 1;
    }
  }
}