
pragma solidity ^0.4.19;

import "./kittyBreed.sol";

contract kittySell is kittyBreed {
    
    uint PRICE = 1 wei;
//contract kittyAuction{
    event AuctionCreated(uint256 tokenId, uint256 price);
    struct Auction {
        address seller;
        uint price;
    }

    mapping(uint256 => Auction) internal tokenIdToAuction;

    function createAuction(uint256 _tokenId, uint256 _price) external onlyOwnerOf(_tokenId) {
 //function createAuction(uint256 _tokenId, uint128 _price) public {
        Auction memory _auction = Auction({
           seller:msg.sender,
           price:_price
        });

        tokenIdToAuction[_tokenId] = _auction;
        emit AuctionCreated(_tokenId, _price);
    }

    function cancelAuction(uint256 _tokenId) external onlyOwnerOf(_tokenId) {
 // function cancelAuction(uint256 _tokenId) public {
        delete tokenIdToAuction[_tokenId];
    }

    function getAuctionByKitty(uint256 _tokenId) public view returns (address seller, uint256 price) {
        Auction storage _auction = tokenIdToAuction[_tokenId];
        seller = _auction.seller;
        price = _auction.price;
    }
    
    function isSell(uint256 _tokenId) public view returns(bool) {
        if(tokenIdToAuction[_tokenId].seller != address(0)) {
            return true;
        } else {
            return false;
        }
    }
    
    function buyKitty(uint256 _tokenId) public payable {
        require(msg.value >= price * PRICE);
        uint256 price;
        address own;
        (own, price) = getAuctionByKitty(_tokenId);
        uint cut = msg.value - price * PRICE;
        own.send(msg.value);
        msg.sender.send(cut);
        delete tokenIdToAuction[_tokenId];
        _transfer(own, msg.sender, _tokenId);
        
    }

}
