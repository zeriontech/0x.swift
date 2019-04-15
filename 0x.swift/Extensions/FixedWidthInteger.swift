//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// FixedWidthInteger.swift
//
// Created by Igor Shmakov on 15/04/2019
//

import Foundation

extension FixedWidthInteger {
    
    func getTypedData(size: Int) -> Data {
        var intValue = self.bigEndian
        var data = Data(buffer: UnsafeBufferPointer(start: &intValue, count: 1))
        let num = size / 8 - 8
        if num > 0 {
            data.insert(contentsOf: [UInt8].init(repeating: 0, count: num), at: 0)
        } else if num < 0 {
            data = data.advanced(by: abs(num))
        }
        return data
    }
}
