// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract fiver is ERC721Enumerable, Ownable {
    using Strings for uint256;
    string _baseTokenURI = "";
    string baseExtension = ".json";
    bool public _paused;
    bool public revealed;
    uint256 public _price = 0 ether;
    uint256 public maxTokenIds = 4;
    uint256 public tokenIds;

    
    modifier onlyWhenNotPaused {
        require(!_paused, "Contract currently paused");
        _;
    }

    constructor () ERC721("Fiver", "fiver") {}

    function mint() public payable onlyWhenNotPaused {
        require(tokenIds < maxTokenIds, "Exceed maximum supply");
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds += 1;
        address _owner = owner();
        (bool sent, ) =  _owner.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
        _safeMint(msg.sender, tokenIds);
    }

    function setBaseTokenURI(string memory URI) public{
        _baseTokenURI = URI;
        revealed = true;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return string(abi.encodePacked("ipfs://",_baseTokenURI,"/"));
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory baseURI = _baseURI();
        return revealed ? string(abi.encodePacked(baseURI, tokenId.toString(),baseExtension)) : "";
    }

    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }
    
    receive() external payable {}
    fallback() external payable {}
}
