// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AVGPriceV3 {
    uint public price;

    function setPrice(uint _price) external {
        price = _price;
    }


}