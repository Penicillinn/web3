// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 部署时候传入地址参数和需要的签名数
// 多个 owner 地址
// 发起交易的最低签名数
// 有接受 ETH 主币的方法，
// 除了存款外，其他所有方法都需要 owner 地址才可以触发
// 发送前需要检测是否获得了足够的签名数
// 使用发出的交易数量值作为签名的凭据 ID（类似上么）
// 每次修改状态变量都需要抛出事件
// 允许批准的交易，在没有真正执行前取消。
// 足够数量的 approve 后，才允许真正执行。
  
contract MultiSigWallet {
  // 所有的 owner
  address[] public owners;
  // 交易需要的签名数量
  uint256 public requiredSigCount;
  // 判断是否是owner
  mapping(address => bool) public isOwner;
  // 判断某个交易是否被签名过
  mapping(uint256 => mapping(address => bool)) public approvals ;

  struct Transaction {
    address to;
    uint256 value;
    bytes data;
    bool executed;
  }

  Transaction[] transactions;


  event Deposit(address indexed sender, uint256 amount);
  event Submit(uint256 indexed txId);
  event Approve(address indexed owner, uint256 indexed txId);
  event Revoke(address indexed owner, uint256 indexed txId);
  event Execute(uint256 indexed txId);

  constructor(address[] memory _owners, uint256 _requiredSigCount) {
    // 判断输入值
    require(_owners.length > 0, "Owner address can not be empty");
    require(_requiredSigCount <= _owners.length, "RequiredSigCount out of boundary");
    for(uint256 i = 0; i < _owners.length; i++) {
      address owner = _owners[i];
      // 检测非空地址、重复添加
      require(owner != address(0), "Invalid address");
      require(!isOwner[owner], "Owner must be unique");
      isOwner[owner] = true;
      owners.push(owner);
    }
    requiredSigCount = _requiredSigCount;
  }
  // 校验是否是owner
  modifier onlyOwner {
    require(isOwner[msg.sender], "Only owner can call this function");
    _;
  }
  // 校验 交易 是否存在
  modifier txIdExists(uint256 _txId) {
    require(_txId < transactions.length, "TxId out of boundary");
    _;
  }

  // 校验 交易 是否被签名过
  modifier txIdNotApproval(uint256 _txId) {
    require(!approvals[_txId][msg.sender], "Transaction has already been signed");
    _;
  }

  // 校验 交易 是否被执行过了
  modifier txIdNotexecuted(uint256 _txId) {
    require(!transactions[_txId].executed, "Transaction has already been executed");
    _;
  }

  // 查询账户余额
  function getBalance() public view returns(uint256) {
    return address(this).balance;
  }

  // 获取交易的签名数量
  function getTransactionSign(uint256 _txId) 
    public 
    view 
    onlyOwner 
    txIdExists(_txId) 
    returns(uint256 count) 
  {
    for(uint256 i = 0; i < owners.length; i++) {
      if(approvals[_txId][owners[i]]) {
        count++;
      }
    }
  }

  // 提交交易申请
  function submit(address _to, uint256 _value, bytes calldata _data) 
    public 
    onlyOwner 
    returns(uint256) 
  {
    transactions.push(Transaction(_to, _value, _data, false ));
    emit Submit(transactions.length - 1);
    return transactions.length - 1;
  }

  // 对交易进行签名
  function approve(uint _txId)
    public 
    onlyOwner
    txIdExists(_txId) 
    txIdNotApproval(_txId)
    txIdNotexecuted(_txId)
  {
    approvals[_txId][msg.sender] = true;
    emit Approve(msg.sender, _txId);
  }

  // 取消对交易的签名
  function revoke(uint256 _txId) 
    public 
    onlyOwner 
    txIdExists(_txId) 
    txIdNotexecuted(_txId)
  {
    approvals[_txId][msg.sender] = false;
    emit Revoke(msg.sender, _txId);
  }

  // 执行交易
  function execute(uint256 _txId) 
    public 
    payable
    onlyOwner
    txIdExists(_txId) 
    txIdNotexecuted(_txId)
    {
      require(getTransactionSign(_txId) >= requiredSigCount, "Signatures has not been reached");
      Transaction storage transaction = transactions[_txId];
      transaction.executed = true;
      (bool success, ) = payable(transaction.to).call{value: transaction.value }(transaction.data);
      require(success, "Transaction failed");
      emit Execute(_txId);
    }


  receive() external payable {
    emit Deposit(msg.sender, msg.value);
  }
  fallback() external payable {
    emit Deposit(msg.sender, msg.value);
  }
}