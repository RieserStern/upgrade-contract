// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AVGPriceV1.sol";

contract AVGPriceV2 is AvgPriceV1 {
    address private _owner;

    uint256 public y;
    uint public ownerPrice;

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns(bool) {
        return msg.sender == _owner;
    }

    function setOwnerPrice(uint _price) external onlyOwner  {
        ownerPrice = _price;
    }
}
