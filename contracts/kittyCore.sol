pragma solidity ^0.4.19;

import "./kittySireSell.sol";

contract kittyCore is kittySireSell {
    function kittyCore() public{
        owner = msg.sender;
    }
}