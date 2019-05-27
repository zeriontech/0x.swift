//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ERC20Tests.swift
//
// Created by Vadim Koleoshkin on 16/04/2019
//

import Nimble
import Quick
import Web3Swift

@testable import Swifty0x

class ERC20Tests: XCTestCase {

    enum ERC20TestsErrors: Error {
        case invalidNumber
    }

    // ZRX Token
    let token = ERC20Token(
        contract: EthAddress(
            hex: "0xe41d2489571d322189246dafa5ebde1f4699f498"
        ),
        network: AlchemyNetwork(
            chain: "mainnet",
            apiKey: "ETi2ntZoWxd6nTI1qE13Q4I1eLB8AMDl"
        )
    )

    //ZRX foundation address
    let address = EthAddress(
        hex: "0x606af0bd4501855914b50e2672c5926b896737ef"
    )

    func testName() {
        expect{
            try self.token.name()
        }.to(
           equal("0x Protocol Token"),
           description: "Token should be named correctly"
        )
    }

    func testDecimals() {
        expect{
            guard let number = try Decimal(
                string: HexAsDecimalString(
                    hex: self.token.decimals()
                ).value()
            ) else {
                throw ERC20TestsErrors.invalidNumber
            }
            return number
        }.to(
            equal(Decimal(18)),
            description: "Token should have correct decimals"
        )
    }

    func testSymbol() {
        expect{
            try self.token.symbol()
        }.to(
            equal("ZRX"),
            description: "Token should have correct symbol"
        )
    }

    func testBalanceOf() {
        expect{
            guard let number = try Decimal(
                string: HexAsDecimalString(
                    hex: self.token.balanceOf(
                        owner: self.address
                    )
                ).value()
            ) else {
                throw ERC20TestsErrors.invalidNumber
            }
            return number
        }.to(
            beGreaterThan(Decimal(0)),
            description: "Token balance should be greater than 0"
        )
    }

    func testAllowance() {
        expect{
            guard let allowance = try Decimal(
                string: HexAsDecimalString(
                    hex: self.token.allowance(
                        owner: self.address,
                        spender: self.address
                    )
                ).value()
            ) else {
                throw ERC20TestsErrors.invalidNumber
            }
            return allowance
        }.to(
            equal(Decimal(0)),
            description: "Token allowance should be equal to 0"
        )
    }
}
