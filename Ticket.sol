// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Ticket is ERC721,Ownable{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    
    mapping(address=>uint256) public userDetails;
    mapping(address=>uint256) public ticketQuantity;
    event ticketBuysuccessfully(uint256 eventId,uint256 quantity);
    uint256 public totalTicketSold;

    constructor() ERC721("Ticket", "TK") {
    }
    /* 
    * @dev:This function is used to buy the tickets for a particular event and then mint it to NFT,
    * @params: price,quantity,eventId
    */
    function buyNFT(uint256 price,uint256 quantity,uint256 eventId)public payable {
        require(msg.value==price*quantity*1e18,"ether is not enough");
         uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender,tokenId);
        userDetails[msg.sender] = eventId;  
        ticketQuantity[msg.sender] = quantity; 
        emit ticketBuysuccessfully(eventId, quantity);     
    }

    function withdrawl() external {
        require(msg.sender == owner(),"Only contract owner can withdraw funds");
        payable(msg.sender).transfer(address(this).balance);

    }

    function getUserDetails(address account) public view returns(uint256){
        return userDetails[account];
    }


}