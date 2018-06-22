pragma solidity ^0.4.19;

import "./kittyBase.sol";
import "./erc721.sol";

contract kittyOwner is kittyBase,ERC721 {

    //modifier
    modifier onlyOwnerOf(uint256 _tokenId) {
        require(msg.sender == kittyToOwner[_tokenId]);
        _;
    }

    //return the count of the owner
    function balanceOf(address _owner) public view returns(uint256) {
        return ownerTokenCount[_owner];
    }

    //return the owner of the _tokenId
    function ownerOf(uint256 _tokenId) public view returns(address) {
        return kittyToOwner[_tokenId];
    }

    //transfer _tokenId
    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        _transfer(msg.sender, _to, _tokenId);
    }

    //set the approve of the _token
    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        kittyApproves[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    //approval adopt the _tokenId
    function takeOwnership(uint256 _tokenId) public {
        require(msg.sender == kittyApproves[_tokenId]);
        address owner = ownerOf(_tokenId);      //get the owner of the _tokenId
        _transfer(owner, msg.sender, _tokenId);

    }

    //return a tokenId[] of the _owner;
    function getKittiesByOwner(address _owner) external view returns(uint[]) {
        uint[] memory result = new uint[](ownerTokenCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < kitties.length; i++) {
            if (kittyToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;

    }
}
    
