//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ERC20Encoder.swift
//
// Created by Vadim Koleoshkin on 10/04/2019
//

import Web3Swift

class SimpleERC20Encoder: SimpleABIEncoder {
    
    func totalSupply() -> EncodedABIFunction {
        return encodeStaticFunction(
            function: "totalSupply()"
        )
    }
    
    func balanceOf(owner: EthAddress) -> EncodedABIFunction {
        return encode(
            function: "balanceOf()",
            parameters: [
                ABIAddress(
                    address: owner
                )
            ]
        )
    }
    
    func transfer(to: EthAddress, value:EthNumber) -> EncodedABIFunction {
        return encode(
            function: "transfer(address,uint256)",
            parameters: [
                ABIAddress(
                    address: to
                ),
                ABIUnsignedNumber(
                    origin: value
                ),
            ]
        )
    }
    
    func transferFrom(from: EthAddress, to: EthAddress, value: EthNumber) -> EncodedABIFunction {
        return encode(
            function: "transferFrom(address,address,uint256)",
            parameters: [
                ABIAddress(
                    address: from
                ),
                ABIAddress(
                    address: to
                ),
                ABIUnsignedNumber(
                    origin: value
                ),
            ]
        )
    }
    
    func approve(spender: EthAddress, value: EthNumber) -> EncodedABIFunction {
        return encode(
            function: "approve(address,uint256)",
            parameters: [
                ABIAddress(
                    address: spender
                ),
                ABIUnsignedNumber(
                    origin: value
                ),
            ]
        )
    }
    
    func allowance(owner: EthAddress, spender: EthAddress) -> EncodedABIFunction {
        return encode(
            function: "allowance(address,address)",
            parameters: [
                ABIAddress(
                    address: owner
                ),
                ABIAddress(
                    address: spender
                ),
            ]
        )
    }
    
}

extension SimpleERC20Encoder {
    
    func name() -> EncodedABIFunction {
        return encodeStaticFunction(function: "name()")
    }
    
    func symbol() -> EncodedABIFunction {
        return encodeStaticFunction(function: "symbol()")
    }
    
    func decimals() -> EncodedABIFunction {
        return encodeStaticFunction(function: "decimals()")
    }
    
}

class SimpleABIEncoder: ABIEncoder {
    
    func encodeStaticFunction(function: String) -> EncodedABIFunction {
        return encode(function: function, parameters: [])
    }
    
    func encode(function: String, parameters: [ABIEncodedParameter]) -> EncodedABIFunction {
        return EncodedABIFunction(
            signature: function,
            parameters: parameters
        )
    }
    
}

protocol ABIEncoder {
    
    func encode(
        function: String,
        parameters: [ABIEncodedParameter]
    ) -> EncodedABIFunction
    
}
