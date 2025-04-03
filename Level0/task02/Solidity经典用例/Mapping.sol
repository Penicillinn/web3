// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
  
contract Mapping {
  mapping (address => uint) public infos;

  function addInfo(address _addr, uint value) public {
    infos[_addr] = value;
  }

  function getInfo(address _aadr) public view returns (uint) {
    return infos[_aadr];
  }

  function deleteInfo(address _addr) public {
    delete infos[_addr];
  }
}

contract NestedMapping {
  mapping(address => mapping(uint => bool)) public userInfos;

  function addUserInfo(address _address, uint id, bool hasBook) public {
    userInfos[_address][id] = hasBook;
  }

  function editUserInfo(address _address, uint id, bool hasBook) public {
    userInfos[_address][id] = hasBook;
  }

  function getUserInfo(address _address, uint id) public view returns(bool) {
    return userInfos[_address][id];
  }
}