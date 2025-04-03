// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
  
contract WrappedEther {
  string public name = "WrappedEther";
  string public symbol = "Weth";
  uint8 public decimals = 18;
  uint256 total = 0;

  mapping(address => uint256) balances;
  mapping(address => mapping(address => uint256)) allowanceOf;

  event Transfer(address indexed from, address indexed to, uint256 amount);
  event Approval(address indexed owner, address indexed spender, uint256 amount);

  constructor(uint256 _total) {
    total = _total;
  }

  function mint(address recipient, uint256 amount) 
    public 
    hasAddress(recipient)
    notZero(amount) 
  {
    balances[recipient] = amount;
  }

  function totalSupply() public view returns(uint256){
    return total;
  }

  function balanceOf(address account) 
    public 
    view 
    hasAddress(account) 
    returns(uint256)
  {
    return balances[account];
  }

  function approve(address spender, uint256 amount) 
    public 
    hasAddress(spender)
    notZero(amount)
  {
    uint256 ownerAmount = balances[msg.sender];
    require(ownerAmount >= amount, "Insufficient owner balance");
    allowanceOf[msg.sender][spender] = amount;
    emit Approval(msg.sender, spender, amount);
  }

  function allowance(address owner, address spender) 
    public 
    view 
    hasAddress(owner)
    hasAddress(spender)
    returns(uint256)
  {
    return allowanceOf[owner][spender];
  }

  function transfer(address recipient, uint256 amount) 
    public 
    hasAddress(recipient)
    notZero(amount)
  {
    require(balances[msg.sender] >= amount, "Insufficient owner balance");
    balances[msg.sender] -= amount;
    balances[recipient] += amount;
    emit Transfer(msg.sender, recipient, amount);
  }

  function transferFrom(address sender, address recipient, uint256 amount) 
    public 
    hasAddress(sender)
    hasAddress(recipient)
    notZero(amount)
  {
    uint256 ownerAmount = balances[sender];
    uint256 spenderAmount = allowanceOf[sender][msg.sender];
    require(ownerAmount >= amount && spenderAmount >= amount, "Insufficient balance");
    balances[sender] -= amount;
    allowanceOf[sender][msg.sender] -= amount;
    balances[recipient] += amount;
    emit Transfer(sender, recipient, amount);
  }


  modifier hasAddress(address addr) {
    require(addr != address(0), "Invalid address");
    _;
  }

  modifier notZero(uint256 amount) {
    require(amount > 0,  "Amount must be greater than zero");
    _;
  }
}