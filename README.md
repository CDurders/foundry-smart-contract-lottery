# Provably Random Raffle Contracts

##

This code is to create a provably random smart contract lottery.

## What does it do?

1. Users can enter by paying for a ticket
    1. The ticket fees are going to go to the winner during the draw
2. After X period of time, the lottery will automatically draw a winner
    1. This is done programatically
3. Usiong Chainlink VRF & Chainlink Automation
    1. Chainlin VRF -> Randomness
    2. Chainlink Automation -> Time-based trigger


## Tests
1. Write some deploy scripts
2. Write the tests
    1. Work on a local chain
    2. Forked Testnet
    3. Forked Mainnet
