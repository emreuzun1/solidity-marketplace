// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Adesso is ERC721, ERC721Enumerable, Ownable {
    address public _owner;
    uint256 public mintPrice;
    uint256 public maxSupply;
    uint256 private tokenId;
    string internal baseTokenUri;

    constructor() Ownable(msg.sender) ERC721("Adesso", "ADS") {
        _owner = msg.sender;
        mintPrice = 0.001 ether;
        maxSupply = 50;
        tokenId = 0;
    }

    function setBaseTokenUri(string calldata _baseTokenUri) external onlyOwner {
        baseTokenUri = _baseTokenUri;
    }

    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        return
            string(
                abi.encodePacked(
                    baseTokenUri,
                    Strings.toString(_tokenId),
                    ".json"
                )
            );
    }

    function mint(uint256 _quantity) public payable {
        require(
            msg.value == _quantity * mintPrice,
            "You have not enough money!"
        );
        for (uint256 i = 0; i < _quantity; i++) {
            uint256 newTokenId = totalSupply() + 1;
            _safeMint(msg.sender, newTokenId);
        }
    }

    function tokensOfOwner(
        address owner
    ) external view returns (uint256[] memory) {
        uint256 count = balanceOf(owner);
        if (count <= 0) return new uint256[](0);
        uint256[] memory tokens = new uint256[](count);
        for (uint i = 0; i < count; i++) {
            tokens[i] = tokenOfOwnerByIndex(owner, i);
        }
        return tokens;
    }

    function _increaseBalance(
        address account,
        uint128 value
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _update(
        address to,
        uint256 _tokenId,
        address auth
    ) internal virtual override(ERC721, ERC721Enumerable) returns (address) {
        return super._update(to, _tokenId, auth);
    }
}
