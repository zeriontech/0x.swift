//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ERC721Metadata.swift
//
// Created by Vadim Koleoshkin on 24/04/2019
//

import Web3Swift

protocol ERC721Metadata {
    
    //Calls
    func name() throws -> String?
    
    func symbol() throws ->  String?
    
    func tokenURI(tokenId: EthNumber) throws ->  String?
    
}
