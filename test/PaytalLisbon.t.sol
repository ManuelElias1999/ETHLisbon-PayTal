// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {PaytalLisbon, Coin} from "../src/PaytalLisbon.sol";
import {Erc20Token} from "../src/Erc20Token.sol";
import {Chronicles} from "../src/Chronicles.sol";

import "forge-std/console.sol";


contract PaytalTest is Test {
    address[] accounts = [address(100_000), address(100_001), address(100_002)];

    PaytalLisbon public paytal;
    Erc20Token public usdt;
    Erc20Token public eth;
    Erc20Token public gno;

    Chronicles public usdtUsd;
    Chronicles public ethUsd;
    Chronicles public gnoUsd;

    function setUp() public {
        usdt = new Erc20Token();
        eth = new Erc20Token();
        gno = new Erc20Token();

        usdtUsd = new Chronicles(999_998 * 1e12);
        ethUsd = new Chronicles(1_820 * 1e18);
        gnoUsd = new Chronicles(112 * 1e18);

        paytal = new PaytalLisbon(
            address(usdt),
            address(eth),
            address(gno),
            address(usdtUsd),
            address(ethUsd),
            address(gnoUsd)
        );
    }

    function test_pay_with_first_token() public {
        usdt.mint(accounts[0], 100 * 1e6);
        paytal.getPriceCombination(90 * 1e18, accounts[0]);
    }

    function test_pay_with_second_token() public {
        usdt.mint(accounts[0], 30 * 1e6);
        eth.mint(accounts[0], 0.044 * 1e18);
        paytal.getPriceCombination(90 * 1e18, accounts[0]);
    }

    function test_pay_with_third_token() public {
        usdt.mint(accounts[0], 30 * 1e6);
        eth.mint(accounts[0], 0.0003 * 1e18);
        gno.mint(accounts[0], 100 * 1e18);
        (
            Coin[3] memory result,
            bool success
        ) = paytal.getPriceCombination(90 * 1e18, accounts[0]);
        assertEq(result[0].amountInCoin, 30000000);
        assertEq(result[0].amountInUsd, 29999940000000000000);

        assertEq(result[1].amountInCoin, 300000000000000);
        assertEq(result[1].amountInUsd, 546000000000000000);

        assertEq(result[2].amountInCoin, 530839821428571428);
        assertEq(result[2].amountInUsd, 59454060000000000000);

        assertEq(success, true);
    }

    // function testFuzz_SetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
