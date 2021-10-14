//
//  SwiftFunctions.swift
//  SwiftSyntexDemo
//
//  Created by uwei on 2019/4/28.
//  Copyright © 2019 Tencent. All rights reserved.
//

import Foundation

protocol P {}
extension String: P {}


class SwiftFunctions {
    init() {
        debugPrint("1,2,3")
        debugPrint(1, 2, 3, separator:"##")
        for n in 1...5 {
            debugPrint(n, terminator: "!") // 替换换行符为指定字符
        }
        var separated = ""
        debugPrint(1.0, 2.0, 3.0, 4.0, 5.0, separator: " ... ", to: &separated)
        print(separated)
        print(dump(Person(name: "uwei")))
        
        let arrayOfInt: [Int] = [1, 2, 3]
        let arrayOfUInt: [UInt] = [1, 2, 3]
//        if arrayOfUInt == (arrayOfInt as [UInt]) { // compile error
        if arrayOfUInt == (arrayOfInt.map(numericCast) as [UInt]) {
            print("numbercast ok")
        }
        
        let floatV:Int8 = 1
        let intV:Int = 1
        
//        if intV + floatV == 2 { // 类型不同，不允许操作
//            print("equal")
//        } else {
//            print("not equal")
//        }
        
        if intV + numericCast(floatV) == 2 {
            print("2")
        } else {
            print("not 2")
        }
        
        
        
        let persons = repeatElement(Person(name: "uwei"), count: 3)
        for p in persons {
            print(p)
        }
        
/*
        // Walk the elements of a tree from a node up to the root
        for node in sequence(first: leaf, next: { $0.parent }) {
            // node is leaf, then leaf.parent, then leaf.parent.parent, etc.
        }
 */
        
        for value in sequence(first: 1, next: { $0 * 2 }) {
            if value == 128 {
                break
            }
            print(value)
        }
        
//        let seq1 = [1,2,3]
//        let seq2 = [2,3,4]
//        sequence(state: (false, seq1.makeIterator(), seq2.makeIterator()), next: { iters in
//            iters.0 = !iters.0
//            return iters.0 ? iters.1.next() : iters.2.next()
//        })
        
        for countdown in stride(from: 3, to: 0, by: -1) {
            print("\(countdown)...")
        }
        
        
        let fermata = "Fermata 𝄐"
        let bytes = fermata.utf8
        print(Array(bytes))
        // Prints "[70, 101, 114, 109, 97, 116, 97, 32, 240, 157, 132, 144]"
        
        var codeUnits: [UTF32.CodeUnit] = []
        let sink = { codeUnits.append($0) }
        transcode(bytes.makeIterator(), from: UTF8.self, to: UTF32.self,
                  stoppingOnError: false, into: sink)
        print(codeUnits)
        // Prints "[70, 101, 114, 109, 97, 116, 97, 32, 119056]"
        
        
        
        let stringAsP: P = "Hello!"
        printGenericInfo(stringAsP)
        
        let words = ["one", "two", "three", "four"]
        let numbers = 1...4
        
        // 合并数组
        for (word, number) in zip(words, numbers) {
            print("\(word): \(number)")
        }
        // 元组数组
        let ua = zip(words, numbers).map{$0}
        print(ua)
        // 字典
        let ud = Dictionary(uniqueKeysWithValues: zip(words, numbers))
        print(ud)
        // 字典，且去掉重复的键
        let fruits = ["Apple", "Pear", "Pear", "Orange"]
        let dic = Dictionary(zip(fruits, repeatElement(1, count: fruits.count)), uniquingKeysWith: +)
        print(dic)
        
        print("intput something:")
        let input = readLine()
        print(input ?? "nothing")
    }
    
    
    func random(in rang: Range<Int>) -> Int {
        // 需要进行类型强制转换，2次
//        return Int(arc4random_uniform(UInt32(rang.count))) + rang.lowerBound
        return numericCast(arc4random_uniform(numericCast(rang.count))) + rang.lowerBound // 当值超过 UInt32.max 时会造成崩溃！
    }
    
    func printGenericInfo<T>(_ value: T) {
//        let typ = type(of: value) // 有问题, 出现这种意外结果是因为对printGenericInfo（_ :)中的type（of：value）的调用必须返回一个是T.Type实例的元类型，但String.self（预期的动态类型）不是P的实例，要在此通用上下文中获取动态类型内部值，请在调用type（of :)时将参数强制转换为Any。
        let typ = type(of: value as Any) // 有问题
        print("'\(value)' of type '\(typ)'")
    }
    
}
