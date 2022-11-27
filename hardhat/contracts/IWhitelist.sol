// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;


interface IWHitelist {
    function whitelistedAddresses(address) external view returns (bool);
}