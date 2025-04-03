// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
  
contract CrowdFunding {
  address public immutable beneficiary;
  uint256 public immutable fundingGoal;
  uint256 public fundingAmount;
  bool private isClose;

  mapping(address => uint) funders;


  event Close(uint256 amount);
  event Withdraw(address recipient, uint256 amount);
  event Deposit(address contributer, uint256 amount);
  event Fund(address contributer, uint amount);
  event ReFund(address contributer, uint amount);


  constructor(address _beneficiary, uint256 _fundingGoal) {
    beneficiary = _beneficiary;
    fundingGoal = _fundingGoal;
  }

  function fund() public payable {
    require(!isClose, "Funding is closed");
    // 距离目标金额的差值
    uint256 remainingGoal = fundingGoal - fundingAmount;
    uint256 fundAmount = msg.value;
    if(msg.value > remainingGoal) {
      // 超出目标金额
      // 投资金额
      fundAmount = remainingGoal;
      // 退回金额
      uint256 refundAmount = msg.value - remainingGoal;
      (bool success, ) = payable(msg.sender).call{value: refundAmount}("");
      require(success, "Refund failed");
      emit ReFund(msg.sender, refundAmount);
    }
      funders[msg.sender] += fundAmount;
      fundingAmount += fundAmount;
      emit Fund(msg.sender, msg.value);
    if(fundingAmount >= fundingGoal) {
      isClose = true;
      emit Close(fundingAmount);
    }
  }

  function close() public onlyBeneficiary {
    require(fundingAmount >= fundingGoal, "FundingGoal is not reached");
    isClose = true;
    emit Close(fundingAmount);
    (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
    require(success, "Close failed");
    emit Withdraw(msg.sender, address(this).balance);
  }


  receive() external payable {
    emit Deposit(msg.sender, msg.value);
  }

  fallback() external payable {
    emit Deposit(msg.sender, msg.value);
  }

  modifier onlyBeneficiary() {
    require(msg.sender == beneficiary, "Only beneficairy can call this function");
    _;
  }
}