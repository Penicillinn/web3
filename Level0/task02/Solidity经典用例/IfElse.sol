// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
  
contract IfElse {
  function foo(uint x) public pure returns(uint) {
    if(x > 10) {
      return 1;
    }else {
      return 2;
    }
  }

  function bar(uint x) public pure returns(uint) {
    return x > 10 ? 1 : 2;
  }
}