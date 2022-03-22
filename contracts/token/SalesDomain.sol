// SPDX-License-Identifier: MIT

pragma solidity =0.8.12;

contract SalesDomain {

    enum AssetType {ERC20, ERC1155}

    struct Asset {
        address token;
        uint tokenId;
        AssetType assetType;
    }

    struct Order {
        /* random number */
        uint salt;

        Asset sellAsset;
        uint sellAmount;

        /* The asset used to buy, how much to pay */ 
        Asset buyAsset;
        uint buyAmount;
    }

    /* An ECDSA signature. */
    struct Sig {
        /* v parameter */
        uint8 v;
        /* r parameter */
        bytes32 r;
        /* s parameter */
        bytes32 s;
    }
}