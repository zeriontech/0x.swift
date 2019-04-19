//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// EIP712SignatureVerifier.swift
//
// Created by Igor Shmakov on 19/04/2019
//

import Foundation
import Web3Swift
import secp256k1_ios
import CryptoSwift

class EIP712SignatureVerifier {
    
    private let context: OpaquePointer
    
    public init() {
        context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))!
    }
    
    deinit {
        secp256k1_context_destroy(context)
    }
    
    func publicKey(signature: inout secp256k1_ecdsa_recoverable_signature, hash: Data) -> secp256k1_pubkey? {
        
        let hash = hash.bytes
        var outPubKey = secp256k1_pubkey()
        let status = secp256k1_ecdsa_recover(context, &outPubKey, &signature, hash)
        return status == 1 ? outPubKey : nil
    }
    
    func convertPublicKey(publicKey: inout secp256k1_pubkey, compressed: Bool) -> Data {
       
        var output = Data(count: compressed ? 33 : 65)
        var outputLen: Int = output.count
        let compressedFlags = compressed ? UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED)
        output.withUnsafeMutableBytes { (pointer: UnsafeMutablePointer<UInt8>) -> Void in
            secp256k1_ec_pubkey_serialize(context, pointer, &outputLen, &publicKey, compressedFlags)
        }
        return output.sha3(.keccak256).suffix(20)
    }
    
    public func convertSignature(signature: Data) -> secp256k1_ecdsa_recoverable_signature {
        
        var sig = secp256k1_ecdsa_recoverable_signature()
        let recid = Int32(signature[64]) - 27
        signature.withUnsafeBytes { (input: UnsafePointer<UInt8>) -> Void in
            secp256k1_ecdsa_recoverable_signature_parse_compact(context, &sig, input, recid)
        }
        return sig
    }
    
    func verify(data: EIP712Hashable, signature: Data, address: EthAddress) throws -> Bool {
        
        var convertedSignature = convertSignature(signature: signature)
        guard var recoveredPublicKey = publicKey(signature: &convertedSignature, hash: try data.hash()) else {
            throw EIP712Error.signatureVerificationError
        }
        return try convertPublicKey(publicKey: &recoveredPublicKey, compressed: false) == address.value()
    }
}
