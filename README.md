# PAYTAL - Prototype

For ETH Lisbon 🚃 Nov 2023 Hackathon

This contract helps a site discover user tokens and distribute a payment into multiple tokens. It leverages the prices feed from the `Chronicles` Oracle.

**Product price**:

```
30 USDT
```

**User tokens in wallet**:

```
- 20 USDT
- 0.001 ETH
- 123 GNO
```

**Payment distribution** example:

```
- 20 USDT + 0.001 ET + 3 GNO == 30 USDT
```

User do not need to swap the tokens to pay in the same currency for a purchase.


```
USDC/USD	0x1173da1811a311234e7Ab0A33B4B7B646Ff42aEC
USDT/USD	0x0bd446021Ab95a2ABd638813f9bDE4fED3a5779a
GNO/USD	0xA28dCaB66FD25c668aCC7f232aa71DA1943E04b8
ETH/USD	0xc8A1F9461115EF3C1E84Da6515A88Ea49CA97660
```

        address usdc,
        0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83

        address eth,
        0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1

        address gno,
        0x9C58BAcC331c9aa871AFD802DB6379a98e80CEdb

        address usdcUsd,
        0x1173da1811a311234e7Ab0A33B4B7B646Ff42aEC

        address ethUsd,
        0xc8A1F9461115EF3C1E84Da6515A88Ea49CA97660

        address gnoUsd
        0xA28dCaB66FD25c668aCC7f232aa71DA1943E04b8


forge create --rpc-url https://rpc.gnosischain.com --constructor-args "0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83" "0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1" "0x9C58BAcC331c9aa871AFD802DB6379a98e80CEdb" "0x1173da1811a311234e7Ab0A33B4B7B646Ff42aEC" "0xc8A1F9461115EF3C1E84Da6515A88Ea49CA97660" "0xA28dCaB66FD25c668aCC7f232aa71DA1943E04b8" --private-key <private-key> src/PaytalLisbon.sol:PaytalLisbon

## Contract deployed in Gnosis chain

https://gnosisscan.io/address/0x8D664Ad52a566F94b1509be7F5293e125A04b872#readContract







**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
