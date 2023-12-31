// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { VRFCoordinatorV2Mock } from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import { LinkToken } from "../../test/mocks/LinkToken.sol";
import { RaffleConfig } from "./RaffleConfig.s.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address vrfCoordinator;
        bytes32 gasLane;
        uint64 subscriptionId;
        uint32 callbackGasLimit;
        address link;
        uint256 deployerKey;
        RaffleConfig raffleConfig;
    }

    uint256 public constant DEFAULT_ANVIL_PRIVATE_KEY 
        = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    
    NetworkConfig public activeNetworkConfig;

    constructor() {
        RaffleConfig raffleConfig = new RaffleConfig();

        if(block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig(raffleConfig);
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig(raffleConfig);            
        }
    }

    function getSepoliaEthConfig(
        RaffleConfig _raffleConfig 
    ) public view returns (NetworkConfig memory) {
        return NetworkConfig({
            vrfCoordinator: 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625,
            gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
            subscriptionId: 0,
            callbackGasLimit: 500000,
            link: 0x779877A7B0D9E8603169DdbD7836e478b4624789,
            deployerKey: vm.envUint("PRIVATE_KEY"),
            raffleConfig: _raffleConfig
        });
    }

    function getOrCreateAnvilEthConfig(
        RaffleConfig _raffleConfig
    ) public returns (NetworkConfig memory) {
        if(activeNetworkConfig.vrfCoordinator != address(0)) {
            return activeNetworkConfig;
        }

        uint96 baseFee = 0.25 ether; // Technically 0.25 LINK as the VRFCoordinator takes LINK
        uint96 gasPriceLink = 1e9; // 1 gwei LINK

        vm.startBroadcast();
        VRFCoordinatorV2Mock vrfCoordinatorMock = new VRFCoordinatorV2Mock(baseFee, gasPriceLink);
        LinkToken link = new LinkToken();
        vm.stopBroadcast();

        return NetworkConfig({
            vrfCoordinator: address(vrfCoordinatorMock),
            gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
            subscriptionId: 0,
            callbackGasLimit: 500000,
            link: address(link),
            deployerKey: DEFAULT_ANVIL_PRIVATE_KEY,
            raffleConfig: _raffleConfig
        });
    }
}