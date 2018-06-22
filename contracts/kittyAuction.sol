pragma solidity ^0.4.19;

import "./kittyBreed.sol";

contract kittyAuction is kittyBreed {
    event AuctionCreated(uint256 tokenId, uint128 price);
    struct Auction {
        address seller;
        uint128 price;
    }

    mapping(uint256 => Auction) tokenIdToAuction;
    Auction[] public auctions;

    function createAuction(uint256 _tokenId, uint128 _price) external onlyOwnerOf(_tokenId) {
        Auction memory _auction = Auction({
           seller:msg.sender,
           price:_price
        });

        tokenIdToAuction[_tokenId] = _auction;
        auctions.push(_auction);
        emit AuctionCreated(_tokenId, _price);
    }

    function cancelAuction(uint256 _tokenId) external onlyOwnerOf(_tokenId) {
        delete tokenIdToAuction[_tokenId];
    }

    function getAuctionByKitty(uint256 _tokenId) external returns (address seller, uint128 price) {
        Auction storage _auction = tokenIdToAuction[_tokenId];
        seller = _auction.seller;
        price = _auction.price;
    }


}
