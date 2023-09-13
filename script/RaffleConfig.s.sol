// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";

contract RaffleConfig is Script {
    struct RaffleValues {
        uint256 entranceFee;
        uint256 interval;
    }
    
    RaffleValues public raffleValues;

    constructor() {
        raffleValues.entranceFee = 0.01 ether;
        raffleValues.interval = 30;
    }
}