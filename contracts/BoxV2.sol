// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Box.sol";

contract BoxV2 is Box {
    address private _owner;

    uint256 public y;
    uint public ownerPrice;

    constructor() {
        _owner = msg.sender;
    }

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

    // function increment() external {
    //     x += 1;
    // }

    // function setY(uint256 _y) external {
    //     y = _y;
    // }

    // function getY() external view returns(uint256) {
    //     return y;
    // }
}
