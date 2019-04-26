//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// EIP721.swift
//
// Created by Vadim Koleoshkin on 29/03/2019
//

import Foundation
import Web3Swift

protocol EIP712TypedData {
    var types: EIP712Types { get }
    var domain: EIP712Object { get }
    var message: EIP712Object { get }
    var primaryType: String { get }
}

protocol EIP712Types {
    var types : [String: [EIP712Parameter]] { get }
}

protocol EIP712Object {
    var value: AnyObject { get } //string | number | EIP712Object
}

protocol EIP712Parameter {
    var name: String { get }
    var type: String { get }
}

protocol EIP712DomainWithDefaultSchema {
    var name: String? { get }
    var version: String? { get }
    var verifyingContractAddress: String { get }
}
