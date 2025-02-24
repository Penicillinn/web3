// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
  
contract Array {
  uint[] public arr;

  function getEleByIndex(uint index) public view returns(uint) {
    return arr[index];
  }

  function getArr() public view returns(uint[] memory) {
    return arr;
  }

  function push(uint ele) public {
    arr.push(ele);
  }

  function pop() public {
    arr.pop();
  }

  function getLength() public view returns (uint) {
    return arr.length;
  }

  function remove(uint index) public {
    delete arr[index];
  }

  function examples() external pure returns (uint[] memory) {
    uint256[] memory arr1 = new uint256[](5);
    return arr1;
  }
}

contract ArrayRemoveByShiting {
  uint[] public arr;

  function removeEle(uint _index) public {
    uint arrLength = arr.length;
    require(_index < arrLength, "Index out of bound");
    for(uint i = _index; i < arrLength - 1; i++) {
      arr[i] = arr[i+1];
    }
    arr.pop();
  }

  function test() public {
    arr = [1, 2, 3, 4, 5];
    removeEle(2);
    // [1, 2, 4, 5]
    assert(arr[0] == 1);
    assert(arr[1] == 2);
    assert(arr[2] == 4);
    assert(arr[3] == 5);
    assert(arr.length == 4);

    arr = [1];
    removeEle(0);
    // []
    assert(arr.length == 0);
  }
}

contract ArrayReplaceFromEnd {
  uint[] public arr;

  function remove(uint _index) public {
    require(_index < arr.length, 'Index out of bound');
    arr[_index] = arr[arr.length - 1];
    arr.pop();
  }

  function test() public {
    arr = [1,2,3,4];
    remove(1);
    assert(arr.length == 3);
    assert(arr[0] == 1);
    assert(arr[1] == 4);
    assert(arr[2] == 3);
  }
}