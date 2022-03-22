// SPDX-License-Identifier: MIT

pragma solidity =0.8.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

import "./SalesDomain.sol";
import "../utils/Bytes.sol";
import "../utils/String.sol";
import "../utils/Uint.sol";
import "../proxy/ERC20TransferProxy.sol";
import "../proxy/TransferProxy.sol";



contract NFTSales is Ownable, SalesDomain {
    using SafeMath for uint;
    using UintLibrary for uint;
    using StringLibrary for string;
    using BytesLibrary for bytes32;

    event Buy(
        address indexed sellToken, uint256 indexed sellTokenId, uint256 sellValue,
        address seller,
        address buyToken, uint256 buyTokenId, uint256 buyValue,
        address buyer,
        uint256 salt
    );

    /* receiver address for seller */
    address public beneficiary;

    /* signer address of seller side */
    address public sellerSigner;

    /* where the seller asset lies */
    address public seller;

    /* which token can be used to buy */
    mapping(address => bool) public supportedToken;


    ERC20TransferProxy public erc20TransferProxy;
    TransferProxy public transferProxy;

    constructor(
        ERC20TransferProxy _erc20TransferProxy, 
        TransferProxy _transferProxy, 
        address _beneficiary, 
        address _sellerSigner,
        address _seller
    ) {
        erc20TransferProxy = _erc20TransferProxy;
        transferProxy = _transferProxy;
        beneficiary = _beneficiary;
        sellerSigner = _sellerSigner;
        seller = _seller;
    }

    function setBeneficiary(address newBeneficiary) external onlyOwner {
        beneficiary = newBeneficiary;
    }

    function setSellerSigner(address newSellerSigner) external onlyOwner {
        sellerSigner = newSellerSigner;
    }

    function setSeller(address newSeller) external onlyOwner {
        seller = newSeller;
    }

    function addSupportedToken(address token) external onlyOwner {
        supportedToken[token] = true;
    }

    function delSupportedToken(address token) external onlyOwner {
        supportedToken[token] = false;
    }    

    function exchange(
        Order calldata order,
        Sig calldata sig
    ) external {
        validateOrderSig(order, sig);
        require(supportedToken[order.buyAsset.token], "token is not supported");
        require(order.buyAsset.tokenId == 0, "buyer's tokenId should be 0");
        transferProxy.erc1155safeTransferFrom(IERC1155(order.sellAsset.token), seller, msg.sender, order.sellAsset.tokenId, order.sellAmount, "");
        erc20TransferProxy.erc20safeTransferFrom(IERC20(order.buyAsset.token), msg.sender, beneficiary, order.buyAmount);
        emitBuy(order);
    }

    function validateOrderSig(
        Order memory order,
        Sig memory sig
    ) internal view {
        require(prepareMessage(order).recover(sig.v, sig.r, sig.s) == sellerSigner, "incorrect seller signature");
    }

    function prepareMessage(Order memory order) public pure returns (string memory) {
        return keccak256(abi.encode(order)).toString();
    }

    function emitBuy(Order memory order) internal {
        emit Buy(order.sellAsset.token, order.sellAsset.tokenId, order.sellAmount,
            seller,
            order.buyAsset.token, order.buyAsset.tokenId, order.buyAmount,
            msg.sender,
            order.salt
        );
    }

}