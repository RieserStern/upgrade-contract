// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./DateTimeHandle.sol";
import "./AVGInterface.sol";

/**
  *  @author Rieser Stern
  *  @dev Contract for calculate the AVGPrice token
 */
contract AvgPriceV1 is AVGInterface, Ownable, Pausable, DateTimeHandle {
    using SafeMath for uint;

    mapping(uint => uint) private _prices;
    uint private _sumPrice;
    uint private _sumDay;

    /**
     * Set Price
     * @param _price new price for a day
     * @dev Set Price when not paused
     */
    function setPrice(uint _price) external whenNotPaused {
        _prices[block.timestamp.div(3600)] = _price;
        uint256 _month = getMonth(block.timestamp);
        if (_month >= 8 && _month <= 9) {
            _sumDay = _sumDay.add(1);
            _sumPrice = _sumPrice.add(_price);
        }
    }

    /**
     * Get Price
     * @param _date timestamp
     * @dev Get Price
     */
    function getPrice(uint256 _date)
        external
        view
        virtual
        override
        returns (uint256)
    {
        return _prices[_date.div(3600)];
    }

    
    /**
     * Get AVG Price
     * @dev Get Average price from Aug to Sep
     * @return average price from Aug to Sep
     */
    function getAVGPrice() external view virtual override returns (uint256) {
        return _sumPrice.div(_sumPrice);
    }

    /**
     * Pause to set price ( available for only owner )
     * @dev Pause to set the price
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * Unpause to set price ( available for only owner )
     * @dev Unpause to set the price
     */
    function unpause() public onlyOwner {
        _unpause();
    }
}