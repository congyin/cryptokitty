pragma solidity ^0.4.19;

import "./kittyOwner.sol";

contract kittyBreed is kittyOwner {



    function isReady(uint256 _tokenId) public view returns(bool) {
        Kitty storage _kitty = kitties[_tokenId];
        return (uint64(_kitty.cooldown) < uint64(now));
    }


    //return the _tokenId message
    function getKitty(uint256 _tokenId) external view returns(
        bool Ready,
        string genes,
        uint256 matronId,
        uint256 sireId,
        uint256 birthTime,
        uint256 generation) {
            Kitty memory _kitty = kitties[_tokenId];
            Ready = isReady(_tokenId);
            genes = _kitty.genes;
            matronId = _kitty.matronId;
            sireId = _kitty.sireId;
            birthTime = _kitty.birthTime;
            generation = _kitty.generation;

        }


}
