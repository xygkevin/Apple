//
//  types.swift
//  SwiftSyntexDemo
//
//  Created by uwei on 2019/4/28.
//  Copyright © 2019 Tencent. All rights reserved.
//

import Foundation
class SwiftTypes {
    init() {
        var boolV = false;
        print("\(boolV.description)");
        boolV = Bool("true") ?? false
        print("\(boolV.description)");
        boolV = Bool.random()
        if boolV {
            print("ok")
        } else {
            print("no")
        }
        
        let intV = Int(bigEndian: 2048)
        print("\(intV)")
        // 保证不溢出
        print(Int8(clamping: intV))
        
        let intV16:Int16 = -500 // 11111110_00001100
        print(Int8(truncatingIfNeeded: intV16)) // 00001100
        
        let radixInt = Int("123", radix:16) // 将16进制的 123转换为10进制的整数， radix 必须在2...36
        print(radixInt ?? 0)
        
        let intExactly = Int(exactly: 12.1) // 严格限制转换的条件,不进行舍入计算
        print(intExactly ?? 0)
        
        let leadingZeroNo:Int8 = 31 // 0b0001_1111
        print(leadingZeroNo.leadingZeroBitCount)
        let magnitudeInt = -200
        print(magnitudeInt.magnitude)
        
        
        let intV8:Int8 = 1
        var (v, r) = intV8.addingReportingOverflow(1)
        print(v, r)
        (v, r) = intV8.addingReportingOverflow(127)
        print(v, r)
    }
}
