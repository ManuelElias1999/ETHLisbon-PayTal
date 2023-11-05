// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "chronicle-std/src/IChronicle.sol";

contract Chronicles is IChronicle {
    uint256 public price;

    constructor(uint256 _price) {
        price = _price;
    }

    function wat() external view returns (bytes32 wat) {
        bytes32 wat;
        return wat;
    }

    function read() external view returns (uint value) {
        return price;
    }

    function readWithAge() external view returns (uint value, uint age) {
        return (value, age);
    }

    function tryRead() external view returns (bool isValid, uint value) {
        return (isValid, value);
    }

    function tryReadWithAge()
        external
        view
        returns (bool isValid, uint value, uint age) {
            return (isValid, value, age);
        }
}