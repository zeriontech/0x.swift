//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// Data.swift
//
// Created by Igor Shmakov on 12/04/2019
//

import Foundation

extension Data: EIP712Encodable {
   
    func encode() throws -> Data {
        return self
    }
}
