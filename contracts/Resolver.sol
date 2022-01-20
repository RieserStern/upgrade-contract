// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Resolver {
    struct Pointer {
        address destination;
        uint256 outsize;
    }
    mapping(bytes4 => Pointer) public pointers;
    address public fallbackAddr;
    address public admin;
    Resolver public replacement;

    struct LengthPointer {
        bytes4 sig;
        address destination;
    }
    mapping(bytes4 => LengthPointer) public lengthPointers;

    event FallbackChanged(address oldFallback, address newFallback);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Permission only in Admin");
        _;
    }

    constructor(address _fallback) {
        admin = msg.sender;
        fallbackAddr = _fallback;
    }

    // Public API
    function lookup(bytes4 sig, bytes calldata msgData)
        public
        returns (address, uint256)
    {
        if (address(replacement) != address(0)) {
            return replacement.lookup(sig, msgData);
        } // If Resolver has been replaced, pass call to replacement

        return (destination(sig), outsize(sig));
    }

    // Administrative functions

    function setAdmin(address _admin) public onlyAdmin {
        admin = _admin;
    }

    function replace(Resolver _replacement) public onlyAdmin {
        replacement = _replacement;
    }

    function register(
        string memory _signature,
        address _destination,
        uint256 _outsize
    ) public onlyAdmin {
        pointers[stringToSig(_signature)] = Pointer(_destination, _outsize);
    }

    function registerLengthFunction(
        string memory _mainSignature,
        string memory _lengthSignature,
        address _destination
    ) public onlyAdmin {
        lengthPointers[stringToSig(_mainSignature)] = LengthPointer(
            stringToSig(_lengthSignature),
            _destination
        );
    }

    function setFallback(address _fallback) public onlyAdmin {
        emit FallbackChanged(fallbackAddr, _fallback);
        fallbackAddr = _fallback;
    }

    // Helpers

    function destination(bytes4 _sig) public view returns (address) {
        address storedDestination = pointers[_sig].destination;
        if (storedDestination != address(0)) {
            return storedDestination;
        } else {
            return fallbackAddr;
        }
    }

    function outsize(bytes4 _sig) public returns (uint256) {
        if (lengthPointers[_sig].destination != address(0)) {
            // Dynamically sized
            return dynamicLength(_sig);
        } else if (pointers[_sig].destination != address(0)) {
            // Stored destination and outsize
            return pointers[_sig].outsize;
        } else {
            // Default
            return 32;
        }
    }

    function dynamicLength(bytes4 _sig) public returns (uint256 _outsize) {
        uint256 r;
        address lengthDestination = lengthPointers[_sig].destination;
        bytes4 lengthSig = lengthPointers[_sig].sig;

        assembly {
            mstore(mload(0x40), lengthSig)
            calldatacopy(add(4, mload(0x40)), 4, sub(calldatasize(), 4))
            r := delegatecall(
                sub(gas(), 700),
                lengthDestination,
                mload(0x40),
                calldatasize(),
                mload(0x40),
                32
            )
            _outsize := mul(mload(0x40), 32)
        }
        require(r == 1, "Call failed");
    }

    function stringToSig(string memory signature) public pure returns (bytes4) {
        return bytes4(abi.encode(signature));
    }
}
