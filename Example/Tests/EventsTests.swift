//
// This source file is part of the 0x.swift open source project
// Copyright 2019 Thsignature()e 0x.swift Authors
// Licensed under Apache License v2.0
//
// EventsTests.swift
//
// Created by Igor Shmakov on 24/05/2019
//

import Nimble
import Quick
import Foundation
@testable import Web3Swift
@testable import Swifty0x

public final class MockedTransactionLogWithTransfer: TransactionLog {
 
    public func transactionHash() throws -> TransactionHash {
        return EthTransactionHash(
            transactionHash: BytesFromHexString(
                hex: "0x8790901230866dca461f30371f93bd538ab39535bb6c9a57fedbbbdea937ca1e"
            )
        )
    }
    
    public func signature() throws -> BytesScalar {
        return BytesFromHexString(
            hex: "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"
        )
    }
    
    public func topics() throws -> [BytesScalar] {
        return [
            BytesFromHexString(hex: "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"),
            BytesFromHexString(hex: "0x000000000000000000000000fbb1b73c4f0bda4f67dca266ce6ef42f520fbb98"),
            BytesFromHexString(hex: "0x00000000000000000000000009d0de315fce62f67a5588cd877dbc5408d67587"),
        ]
    }
    
    public func data() throws -> ABIMessage {
        return ABIMessage(
            message: "0x0000000000000000000000000000000000000000000000004870b6f94e596c00"
        )
    }
    
    public func index() throws -> EthNumber {
        return EthNumber(hex: "0x02")
    }
    
    public func removed() throws -> BooleanScalar {
        return False()
    }
    
    public func address() throws -> EthAddress {
        return EthAddress(hex: "0xe41d2489571d322189246dafa5ebde1f4699f498")
    }
    
    public func blockHash() throws -> BlockHash {
        return EthBlockHash(hex: "0x51944c28d9ff7a4204a293740eb0afa6c755d3e815ecaeccb4639360098ebe83")
    }
    
    public func blockNumber() throws -> EthNumber {
        return EthNumber(hex: "0x766b66")
    }
    
    public func transactionIndex() throws -> EthNumber {
        return EthNumber(hex: "0x06")
    }
}


class EventsTests: XCTestCase {
    
    let log = MockedTransactionLogWithTransfer()
    
    func testEventSignature() {
        
        expect{
            try ERC20Events.Transfer.verifySignature(log: self.log)
        }.notTo(
            throwError(),
            description: "Make sure log parsing is correct"
        )
    }
    
    func testEventFrom() {
        
        expect{
            let event = try ERC20Events.Transfer(log: self.log)
            return try event.from.value().toHexString()
        }.to(
            equal("fbb1b73c4f0bda4f67dca266ce6ef42f520fbb98"),
            description: "Make sure log parsing is correct"
        )
    }
    
    func testEventTo() {
        
        expect{
            let event = try ERC20Events.Transfer(log: self.log)
            return try event.to.value().toHexString()
        }.to(
            equal("09d0de315fce62f67a5588cd877dbc5408d67587"),
            description: "Make sure log parsing is correct"
        )
    }
    
    func testEventValue() {
        
        expect{
            let event = try ERC20Events.Transfer(log: self.log)
            return try event.value.value().toHexString()
        }.to(
            equal("4870b6f94e596c00"),
            description: "Make sure log parsing is correct"
        )
    }
}
