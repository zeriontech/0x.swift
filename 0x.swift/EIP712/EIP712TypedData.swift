//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// EIP712TypedData.swift
//
// Created by Igor Shmakov on 12/04/2019
//

import Foundation
import SwiftyJSON
import Web3Swift
import BigInt


class EIP712TypedData {
    
    let domainType = "EIP712Domain"
    
    var decodedType: EIP712StructType!
    var decodedMessage: EIP712Encodable!
    var decodedDomain: EIP712Domain!
    
    convenience init(jsonData: Data) throws {
        try self.init(json: try JSON(data: jsonData))
    }
    
    convenience init(jsonString: String) throws {
        try self.init(json: JSON(parseJSON: jsonString))
    }
    
    convenience init(jsonObject: Any) throws {
        try self.init(json: JSON(jsonObject))
    }
    
    init(json: JSON) throws {

        let encodedDomain = json["domain"]
        let encodedMessage = json["message"]
        
        guard
            let encodedTypes = json["types"].dictionary,
            let primaryTypeName = json["primaryType"].string
        else {
            throw EIP712Error.invalidTypedData
        }
        
        let types = try parseTypes(encodedTypes: encodedTypes)

        guard let primaryType = types[primaryTypeName] else {
            throw EIP712Error.invalidTypedDataPrimaryType
        }
        
        guard let domainType = types[domainType] else {
            throw EIP712Error.invalidTypedDataDomain
        }
        
        let domain = try parseDomain(encodedDomain: encodedDomain, type: domainType)
        let referencedTypes = types.values.filter { ![self.domainType, primaryTypeName].contains($0.name) }
        let structType = EIP712StructType(primary: primaryType, referenced: referencedTypes)
        let message = try parseMessage(encodedMessage: encodedMessage, primaryType: primaryType, types: types)
        
        self.decodedType = structType
        self.decodedMessage = message
        self.decodedDomain = domain
    }
    
    func validateParameter(json: JSON, parameter: EIP712Parameter) -> Bool {
        
        let value = json[parameter.name]
        
        if parameter.type == "address" {
            return value.string != nil
        }
        
        if parameter.type == "string" {
            return value.string != nil
        }
        
        // TODO: handle uint8 to uint256, int8 to int256 (???)
        if parameter.type.hasPrefix("int") || parameter.type.hasPrefix("uint") {
            return value.int != nil
        }
        
        if parameter.type.hasPrefix("bytes") && parameter.type != "bytes" {
            return value.string != ""
        }
        
        return false
    }
    
    func parseDomain(encodedDomain: JSON, type: EIP712Type) throws -> EIP712Domain {
        
        guard type.parameters.reduce(true, { $0 && self.validateParameter(json: encodedDomain, parameter: $1) }) else {
            throw EIP712Error.invalidTypedDataDomain
        }

        return EIP712Domain(name: encodedDomain["name"].string,
                            version: encodedDomain["version"].string,
                            chainID: encodedDomain["chainId"].int,
                            verifyingContract: encodedDomain["verifyingContract"].string,
                            salt: encodedDomain["salt"].string?.data())
    }
    
    func parseTypes(encodedTypes: [String: JSON]) throws -> [String: EIP712Type] {
    
        var types = [String: EIP712Type]()
        
        for (name, encodedParameters) in encodedTypes {
            var parameters = [EIP712Parameter]()
            for (_, encodedParameter) in encodedParameters {
                guard
                    let name = encodedParameter["name"].string,
                    let type = encodedParameter["type"].string
                else {
                    throw EIP712Error.invalidTypedDataType
                }
                parameters.append(EIP712Parameter(name: name, type: type))
            }
            let type = EIP712Type(name: name, parameters: parameters)
            types[name] = type
        }
        
        return types
    }
    
    func parseMessage(encodedMessage: JSON, primaryType: EIP712Type, types: [String: EIP712Type]) throws -> EIP712Encodable {
        
        var values = [EIP712Encodable]()
        
        for paramenter in primaryType.parameters {
            let value = encodedMessage[paramenter.name]
            if let type = types[paramenter.type] {
                values.append(try self.parseMessage(encodedMessage: value, primaryType: type, types: types))
            } else {
                values.append(try self.parseValue(parameter: paramenter, value: value.object))
            }
        }
        
        return try values.reduce(Data()) { try $0 + $1.encode() }
    }
    
    func parseValue(parameter: EIP712Parameter, value: Any) throws -> EIP712Encodable {
        
        let encoder = EIP712ParameterEncoder(parameter: parameter, value: value)
        return try encoder.encode()
    }
}

extension EIP712TypedData: EIP712Representable {
    
    func type() throws -> EIP712StructType {
        
        if let type = self.decodedType {
            return type
        } else {
            throw EIP712Error.invalidTypedData
        }
    }
    
    func message() throws -> EIP712Encodable {
       
        if let message = self.decodedMessage {
            return message
        } else {
            throw EIP712Error.invalidTypedData
        }
    }
}
