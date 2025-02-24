// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
    
contract Primitives {
  bool public isActive = true;

  uint8 public u8 = 1;
  uint16 public u16 = 16;
  uint32 private u32 = 32;
  uint64 internal u64 = 64;

  int256 public minInt = type(int256).min;
  int256 public maxInt = type(int256).max;

  address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;

  bytes1 public bt1 = 0x01;
  bytes2 public bt2 = 0xdd01;

  bool public defaultBoo; // false
  uint256 public defaultUint; // 0
  int256 public defaultInt; // 0
  address public defaultAddr; // 0x0000000000000000000000000000000000000000

}