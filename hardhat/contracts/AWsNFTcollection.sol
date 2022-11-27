// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract AWsNFTcollection is ERC721Enumerable, Ownable {

    string _baseTokenURl;

    IWHitelist whitelist;

    bool public presaleStarted;
    uint256 public presaleEnded;

    uint256 public maxTokenIds = 20;
    uint256 public tokenIds;

    uint256 _presalePrice = 0.0005 ether;
    uint256 public _price = 0.001 ether;

    bool public _paused;

    
    constructor(string memory baseURI, address whitelistContract) ERC721("Abdulwahid", "AW"){
        _baseTokenURl = baseURI;
        whitelist = IWHitelist(whitelistContract);
    }

    // for the owner to start the presale
    function startPresale() public onlyOwner{
        presaleStarted = true;

        // presale would be ended after the 5 mintues it started
        presaleEnded = block.timestamp + 10 minutes;
    }

    modifier onlyWhenNotPaused{
        require(!_paused, "Contract Currently Paused");
        _;
    }

    // only for the ones who are whitelisted
    function presale() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp < presaleEnded, "Presale has Ended");
        require(whitelist.whitelistedAddresses(msg.sender), "You are not Whitlisted");
        require(tokenIds < maxTokenIds, "Exceeded Maximum Abdulwahid Supply");
        require(msg.value >= _presalePrice, "Ether sent is token");
        tokenIds +=1;

        _safeMint(msg.sender, tokenIds);
    }

    // for public
    function mint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp >= presaleEnded, "Presale has Ended");
        require(tokenIds < maxTokenIds, "Exceeded Maximum Abdulwahid Supply");
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds +=1;

        _safeMint(msg.sender, tokenIds);
    }

    // _baseURI overides the Openzeppelin's ERC721 implementation which by default
    // works same like getter method
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURl;
    }

    // allow the owner to pause or continue the minting
    function setPaused(bool val) public onlyOwner{
        _paused = val;
    }

    // sends all the ether to the owner of the contract
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        ( bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ethers");
    }

    receive() external payable{}

    fallback() external payable{}


}
