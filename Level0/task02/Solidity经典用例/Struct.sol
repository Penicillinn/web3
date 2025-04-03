// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

contract Struct {
  uint256 totalCount;

  struct Todo {
    string todoName;
    uint id;
    bool isCompleted;
  }

  mapping (uint => Todo) todos;


  function addTodo(string _todoName) public {
    todos[totalCount] = Todo(_todoName, totalCount, false);
    totalCount++;
  }

  function doneTodo(uint id) public {
    todos[id].isCompleted = true;
  }

  function getTodoStatus(uint id) public view returns (bool) {
    return todos[id].isCompleted;
  }
}