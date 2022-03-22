// SPDX-License-Identifier: MIT

pragma solidity =0.8.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "../utils/String.sol";
import "../utils/Uint.sol";

contract HeloToken is ERC20, Ownable {
  using SafeMath for uint256;

  constructor() ERC20("HeloToken", "HELO") {}

  function mint(address account, uint256 amount) external onlyOwner {
    super._mint(account, amount);
  }

  function burn(uint256 amount) external {
    super._burn(_msgSender(), amount);
  }
}