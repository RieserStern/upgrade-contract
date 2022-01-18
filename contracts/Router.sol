pragma solidity ^0.8.0;

// SPDX-License-Identifier: Unlicensed

import "./Resolver.sol";

// Copied from npm installed ether-router package as there are currently no .sol.js files.
contract EtherRouter {
    Resolver resolver;

    constructor(Resolver _resolver) {
        resolver = _resolver;
    }

    fallback() external payable {
        uint256 r;
        address _destination;
        uint256 _outsize;

        // Get routing information for the called function
        (_destination, _outsize) = resolver.lookup(msg.sig, msg.data);

        // Make the call
        assembly {
            // I think we have to use the assembly delegatecall as opposed to the standard one
            // as we can't return a value using the standard one.
            // Note mload(0x40) returns the location of where free memory begins.
            calldatacopy(mload(0x40), 0, calldatasize())
            // delegatecall(gas, address, inMem, insize, outMem, outsize)
            r := delegatecall(
                sub(gas(), 700),
                _destination,
                mload(0x40),
                calldatasize(),
                mload(0x40),
                _outsize
            )
        }

        require(r == 1, "Call failed");

        // Pass on the return value
        assembly {
            return(mload(0x40), _outsize)
        }
    }
}
