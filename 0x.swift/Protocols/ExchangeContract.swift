//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ExchangeContract.swift
//
// Created by Vadim Koleoshkin on 28/03/2019
//

import Foundation
import Web3Swift

protocol ExchangeContract {
    
    func fillOrder(
        order: Order,
        takerAssetFillAmount: EthNumber,
        signature: OrderSignature
    ) throws -> TxHash
    
}

// Empty Ethereum address
protocol EmptyAddress {
    
    // 0x0000000000000000000000000000000000000000
    var address: EthAddress { get }
    
}

protocol TxHash {
    
    var hash: FixedLengthBytes { get }
    
}

// An order message consists of the following parameters:
protocol Order {
    
    // Address that created the order.
    var makerAddress: EthAddress { get }
    
    // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.
    var takerAddress: EthAddress { get }
    
    // Address that will receive fees when order is filled.
    var feeRecipientAddress: EthAddress { get }
    
    // Address that is allowed to call Exchange contract methods that affect this order. If set to `EmptyAddress`, any address is allowed to call these methods.
    var senderAddress: EthAddress { get }
    
    // Amount of makerAsset being offered by maker. Must be greater than 0.
    var makerAssetAmount: EthNumber { get }
    
    // Amount of takerAsset being bid on by maker. Must be greater than 0.
    var takerAssetAmount: EthNumber { get }
    
    // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
    var makerFee: EthNumber { get }
    
    // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
    var takerFee: EthNumber { get }
    
    // Timestamp in seconds at which order expires.
    var expirationTimeSeconds: EthNumber { get }
    
    // Arbitrary number to facilitate uniqueness of the order's hash.
    var salt: EthNumber { get }
    
    // ABIv2 encoded data that can be decoded by a specified proxy contract when transferring makerAsset.
    var makerAssetData: BytesScalar { get }
    
    // ABIv2 encoded data that can be decoded by a specified proxy contract when transferring takerAsset.
    var takerAssetData: BytesScalar { get }
    
}

// Could not be fetched from tx
protocol FillResults {
    
    // Total amount of makerAsset(s) filled.
    var makerAssetFilledAmount: EthNumber { get }
    
    // Total amount of takerAsset(s) filled.
    var takerAssetFilledAmount: EthNumber { get }
    
    // Total amount of ZRX paid by maker(s) to feeRecipient(s).
    var makerFeePaid: EthNumber { get }
    
    // Total amount of ZRX paid by taker to feeRecipients(s).
    var takerFeePaid: EthNumber { get }
}

// Information about the order and its state.
protocol OrderInfo {
    
    // Status that describes order's validity and fillability.
    var status: Int8 { get }
    
    // EIP712 hash of the order (see LibOrder.getOrderHash).
    var hash: FixedLengthBytes { get }
    
    // Amount of order that has already been filled.
    var takerAssetFilledAmount: EthNumber { get }
}

protocol OrderSignature {
    
    // Signature proof that orders have been created by makers.
    var signature: BytesScalar { get }
    
    // EIP712 hash of the order (see LibOrder.getOrderHash).
    var hash: FixedLengthBytes { get }
    
    // Order maker address
    var signer: EthAddress { get }
    
}
