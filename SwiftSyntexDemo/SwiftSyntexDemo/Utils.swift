//
//  Utils.swift
//  SwiftSyntexDemo
//
//  Created by uwei on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

import Foundation

func md5(string: String) -> String {
    var digest:[UInt8] = [UInt8](repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
    let data = string.data(using: String.Encoding.utf8)! as NSData
    CC_MD5(data.bytes, CC_LONG(data.length), &digest)
    
    var digestHex = ""
    for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
        digestHex += String(format: "%02x", digest[index])
    }
    
    return digestHex
}

func mapDemo() -> Void {
    let intA = [1, 3, 4]
    let newIntA: [()] = intA.map { print("a = \($0)")
    }

    let newIntAA = intA.map { x -> Int in
        return x + 10
    }
    
    print("map with return = \(newIntAA)")

    var sumIntA = 0
    _ = intA.map {
        sumIntA += $0
    }
}
