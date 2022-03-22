// SPDX-License-Identifier: MIT

pragma solidity =0.8.12;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

library UintLibrary {
    using SafeMath for uint;

    function toString(uint256 i) internal pure returns (string memory) {
        if (i == 0) {
            return "0";
        }
        uint j = i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        unchecked {
            while (i != 0) {
                bstr[k--] = bytes1(uint8(48 + i % 10));
                i /= 10;
            }            
        }
        return string(bstr);
    }
}