pragma solidity 0.8.1;

import "./allowance.sol";


contract SharedWallet is Allowance {
    event MoneySent(address _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount); 

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "There are not enough funds in thre smart contract");
        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }
    
    function renounceOwnership() public override onlyOwner {
        revert("Can't renounce ownership here");
    }

    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);

    }
}