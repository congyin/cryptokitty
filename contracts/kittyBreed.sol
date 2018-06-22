pragma solidity ^0.4.19;

import "./kittyOwner.sol";

contract kittyBreed is kittyOwner {



    function _isReady(uint256 _tokenId) internal view returns(bool) {
        Kitty storage _kitty = kitties[_tokenId];
        return (_kitty.cooldown + cooldownTime < now);
    }


    //return the _tokenId message
    function getKitty(uint256 _tokenId) external view returns(
        bool isReady,
        uint256 genes,
        uint256 matronId,
        uint256 sireId,
        uint256 birthTime,
        uint256 generation) {
            Kitty memory _kitty = kitties[_tokenId];
            isReady = _isReady(_tokenId);
            genes = _kitty.genes;
            matronId = _kitty.matronId;
            sireId = _kitty.sireId;
            birthTime = _kitty.birthTime;
            generation = _kitty.generation;

        }

    function kittyBreed(address _owner) public {
        owner = _owner;
    }
}
