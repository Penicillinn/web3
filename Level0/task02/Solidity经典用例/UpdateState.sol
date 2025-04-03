// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
  
contract UpdateState {
  uint state = 10;

  function setState(uint _state) external {
    state = _state;
  }

  function getState() public view returns (uint) {
    return state;
  }
}