//
//  Pointer.swift
//  SwiftSyntexDemo
//
//  Created by uwei on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

import Foundation

class PointerClass {
    func m0() -> Void {
        // MARK:- About pointer in swift
        var intV = 10
        // 申请内存，类似 C 中的 Int *
        var mpInt = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        // 给内存初始化
        mpInt.initialize(to: intV)
        print(mpInt.pointee)
        intV = mpInt.pointee + 1
        //mpInt.deinitialize()
        //mpInt.deallocate(capacity: 1)
        mpInt.deallocate()

        intV = withUnsafeMutablePointer(to: &intV, { (ptr:UnsafeMutablePointer<Int>) -> Int in
            ptr.pointee += 1
            return ptr.pointee
            })

        print(intV)

        // 类似C中的 void *
        var voidPtr = withUnsafeMutablePointer(to: &intV, { (ptr:UnsafeMutablePointer<Int>) -> UnsafeMutableRawPointer in
            return UnsafeMutableRawPointer(ptr)
            })

        var intP = voidPtr.assumingMemoryBound(to: Int.self)
        print("int p = \(intP.pointee)")


        var array = [1111,2222]
        var arrPtr = UnsafeBufferPointer<Int>(start: &array, count:array.count)
        var basePtr = arrPtr.baseAddress
        print(basePtr?.pointee ?? "")
        var nextPtr = basePtr?.successor()
        print(nextPtr?.pointee ?? "")

        var stringParams = "123455656677"
        let pStr = UnsafeMutablePointer<Int8>.allocate(capacity: stringParams.count)
        pStr.initialize(from: stringParams.cString(using: String.Encoding.utf8)!, count: stringParams.lengthOfBytes(using: .utf8))
        print(showInfo(params: pStr) ?? "default value")

        //let pRawPtr = UnsafeMutableRawPointer.allocate(bytes: stringParams.count, alignedTo: MemoryLayout<String>.alignment)
        let pRawPtr = UnsafeMutableRawPointer.allocate(byteCount: stringParams.count, alignment: MemoryLayout<String>.alignment)
        //let tPtr = pRawPtr.initializeMemory(as: String.self, to: stringParams)
        let ppStr = UnsafeMutablePointer<String>.allocate(capacity:1)
        ppStr.initialize(from: &stringParams, count: 1)
        pRawPtr.initializeMemory(as: String.self, from: ppStr, count: 1)
        print(pRawPtr.load(as: String.self))

        let ttPtr = pRawPtr.initializeMemory(as: Int8.self, from: pStr, count: stringParams.count)
        print(showInfo(params: ttPtr) ?? "default value")


        struct AAA {
            var value:Int
        }
        func initRawAA(p:UnsafeMutableRawPointer) -> UnsafeMutablePointer<AAA> {
            return p.initializeMemory(as: AAA.self, repeating: AAA(value: 1111), count: 1)
        //     p.initializeMemory(as: AAA.self, to: AAA(value: 1111)) // old API
        }

        let rawPtr = UnsafeMutableRawPointer.allocate(byteCount: 1 * MemoryLayout<AAA>.stride, alignment: MemoryLayout<AAA>.alignment)
        let pa = initRawAA(p: rawPtr)
        print(rawPtr.load(as: AAA.self))
        print(pa.pointee.value)


        let count = 4
        // 100 bytes of raw memory are allocated for the pointer bytesPointer, and then the first four bytes are bound to the AAA type.
        let bytesPointer = UnsafeMutableRawPointer.allocate( byteCount: 100, alignment: MemoryLayout<AAA>.alignment)
        let aaaPointer = bytesPointer.bindMemory(to: AAA.self, capacity: count)
        print(aaaPointer.pointee)


        //var mpString = UnsafeMutablePointer<String>(allocatingCapacity: 1)
        var mpString = UnsafeMutablePointer<String>.allocate(capacity: 1)
        mpString.initialize(to: "uwei")
        print(mpString.pointee)
        mpString.deallocate()

    }
}
