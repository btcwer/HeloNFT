
// SPDX-License-Identifier: MIT

pragma solidity =0.8.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

import "../utils/String.sol";
import "../utils/Uint.sol";

contract HeloNFT is Ownable, ERC1155 {
    using SafeMath for uint256;
    using StringLibrary for string;    

    // mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    constructor(string memory URI) ERC1155(URI) {

    }    

    function mint(address to, uint256 id, uint256 amount, bytes memory data, string memory tokenURI) public onlyOwner {
        _mint(to, id, amount, data);
        _tokenURIs[id] = tokenURI;
        emit URI(tokenURI, id);
    }

    function burn(uint256 _id, uint256 _value) external {
        _burn(_msgSender(), _id, _value);
    }

    function setURI(string memory URI) public onlyOwner {
        _setURI(URI);
    }

    function setTokenURI(uint256 id, string memory tokenURI) public onlyOwner {
        _tokenURIs[id] = tokenURI;
    }

    function uri(uint256 id) public view  virtual override returns (string memory) {
        string memory prefixUri = super.uri(id);
        return prefixUri.append(_tokenURIs[id]);
    }

}
