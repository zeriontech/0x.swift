//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ERC165.swift
//
// Created by Vadim Koleoshkin on 24/04/2019
//

import Web3Swift

protocol ERC165 {
    
    //TODO: Consider creating a generic for bytes of length 4
    func supportsInterface(interfaceId: FixedLengthBytes) throws -> Bool
    
}
