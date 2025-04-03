// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
  
contract Todolist {
  struct Todo {
    string name;
    bool done;
  }
  Todo[] private todos;

  event AddTodo(address creator, uint256 index);
  event UpdateTodo(uint index, bool done);

  function createTodo(string memory _name) public {
    todos.push(Todo(_name, false));
    emit AddTodo(msg.sender, todos.length - 1);
  }

  function getTodo(uint256 _index) public view boundCheck(_index) returns (string memory, bool) {
    Todo storage todo = todos[_index];
    return (todo.name ,todo.done);
  }

  function updateTodo(uint256 _index) public boundCheck(_index) {
     todos[_index].done = true;
     emit UpdateTodo(_index, true);
  }

  modifier boundCheck(uint256 _index) {
    require(_index >= 0 && _index < todos.length, "Index Out of boundary");
    _;
  }
}