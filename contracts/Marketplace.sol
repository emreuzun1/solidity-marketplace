// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Marketplace is IERC721Receiver {
    uint256 private saleId;
    uint256[] private allSales;
    mapping(uint256 => Sale) private sales;

    constructor() {
        saleId = 0;
    }

    struct Sale {
        uint256 saleId;
        uint256 tokenId;
        address nftContract;
        uint256 price;
        address payable owner;
        bool isSold;
    }

    event CreateSale(
        uint256 indexed saleId,
        uint256 tokenId,
        address nftContract,
        uint256 price,
        address owner,
        bool isSold
    );

    function getSale(uint256 _saleId) public view returns (Sale memory) {
        return sales[_saleId];
    }

    function createSale(
        uint256 _saleTokenId,
        address _saleNftContract,
        uint256 _price
    ) public {
        IERC721 nft = IERC721(_saleNftContract);
        require(
            nft.ownerOf(_saleTokenId) == msg.sender,
            "You are not the owner!"
        );
        nft.safeTransferFrom(msg.sender, address(this), _saleTokenId);
        saleId = saleId + 1;
        allSales.push(saleId);
        sales[saleId] = Sale(
            saleId,
            _saleTokenId,
            _saleNftContract,
            _price,
            payable(msg.sender),
            false
        );
    }

    function completeSale(uint256 id) public payable {
        Sale memory sale = sales[id];
        require(
            msg.value == sale.price,
            "You have to send the right amount of ether!"
        );
        IERC721(sale.nftContract).safeTransferFrom(
            address(this),
            msg.sender,
            sale.tokenId
        );
        payable(sale.owner).transfer(msg.value);
        sales[id].isSold = true;
    }

    function editSale(uint256 id, uint256 newPrice) public checkSaleOwner(id) {
        sales[id].price = newPrice;
    }

    function cancelSale(uint256 id) public checkSaleOwner(id) {
        Sale memory sale = sales[id];
        IERC721(sale.nftContract).safeTransferFrom(
            address(this),
            sale.owner,
            sale.tokenId
        );
        sales[id].isSold = true;
    }

    function getAllSales() public view returns (Sale[] memory) {
        uint256 saleCount = saleId;
        uint256 currentIndex = 0;
        Sale[] memory resultSales = new Sale[](saleCount);
        for (uint256 i = 1; i <= saleCount; i++) {
            resultSales[currentIndex] = sales[i];
            currentIndex += 1;
        }
        return resultSales;
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    modifier checkSaleOwner(uint256 id) {
        Sale memory sale = sales[id];
        require(msg.sender == sale.owner, "You are not the owner!");
        _;
    }
}
