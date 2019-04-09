//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// String.swift
//
// Created by Igor Shmakov on 09/04/2019
//

import Foundation

extension String {
    
    var data: Data? {
        return self.data(using: .utf8)
    }
}
