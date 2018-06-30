pragma solidity ^0.4.19;

import "./kittySell.sol";

contract kittySireSell is kittySell {
    
    mapping (uint256 => Auction) public sireSell;
    
    function creatSireSell(uint256 _tokenId, uint256 _price) public onlyOwnerOf(_tokenId) {
        Auction memory _auction = Auction({
            seller:msg.sender,
            price:_price
            
        });
        
        sireSell[_tokenId] = _auction;
        
    }
    
    function cancelSireSell(uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        delete sireSell[_tokenId];
    }
    
    function getSireByKitty(uint256 _tokenId) public view returns(address seller, uint256 price) {
        Auction storage _auction = sireSell[_tokenId];
        seller = _auction.seller;
        price = _auction.price;
    }
    
    function isSireSell(uint256 _tokenId) public view returns(bool) {
        if (sireSell[_tokenId].seller != address(0)) {
            return true;
        } else {
            return false;
        }
    }
    
    function buySire(uint256 _tokenId) public payable {
        require(msg.value >= price * PRICE);
        uint256  price;
        address own;
        (own , price)= getSireByKitty(_tokenId);
        uint cut = msg.value - price * PRICE;
        own.send(msg.value);
        msg.sender.send(cut);
    }
    
    
    
    
}