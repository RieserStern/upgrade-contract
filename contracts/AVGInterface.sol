pragma solidity ^0.8.4;

import "./DateTimeHandle.sol";

interface AVGInterface {

    // Get Price
    function getPrice(uint _data) external view returns (uint);

    // Get AVGPrice
    function getAVGPrice() external view returns (uint);
}
