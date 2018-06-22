//@title 智能合约管理权限
pragma solidity ^0.4.19;

contract kittyControl {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    

    //拥有着指派新的拥有着
    function setOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0));
        owner = _newOwner;
    }
}