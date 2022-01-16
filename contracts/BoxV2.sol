// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Box.sol";

contract BoxV2 is Box {
    uint256 public y;

    function increment() external {
        x += 1;
    }

    function setY(uint256 _y) external {
        y = _y;
    }

    function getY() external view returns(uint256) {
        return y;
    }
}
