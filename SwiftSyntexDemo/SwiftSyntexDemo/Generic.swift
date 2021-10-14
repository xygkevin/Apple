//
//  Generic.swift
//  SwiftSyntexDemo
//
//  Created by uwei on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

import Foundation

extension Stack where Element:Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}


// MARK: Generic Type
struct Stack<Element>:Container, Equatable {
    static func == (lhs: Stack<Element>, rhs: Stack<Element>) -> Bool {
        return lhs.count == rhs.count
    }
    // 泛型支持是通过<>符号
    typealias Item = Element
    
    internal subscript(i: Int) -> Element {
        return self.items[i];
    }

    mutating internal func append(_ item: Element) {
        self.items.append(item)
    }

    internal var count: Int {
        return self.items.count
    }

    var items = [Element]()
    // 结构体中，如果某个方法想要改变这个结构体，必须要添加mutating关键字
    mutating func push(item:Element) -> Void {
        self.items.append(item)
    }
    
    mutating func pop() -> Void {
        self.items.removeLast()
    }
}

struct GenericUtils {
    static func find<T1, T2>(p1:T1, p2:T2, p3:String, p4:T2) -> Void {
        print("p1 = \(type(of: p1)), p2 = \(p2), p3 = \(p3), p4 = \(p4)")
    }

    static func find<T1, T2>(p1:T1, p2:T2) -> Void {
        let pt = p1 as! (Int, Int, Int)
        
        print("p1 = \(type(of: p1)), p2 = \(p2), p.0 = \(pt.0)")
    }
    
    // 这个函数只能用于找特定类型String
    func findIndex(target:String, in array:[String]) -> Int? {
        for (index, value) in array.enumerated() {
            if value == target {
                return index
            }
        }
        return nil
    }
    
    
    // 这个函数可以用于满足Equatable协议的类型
    static func findIndex<T:Equatable>(target:T, in array:[T]) -> Int? {
        for (index, value) in array.enumerated() {
            if value == target { // 如果不对类型T进行约束(Equatable)， 则此句编译不通过，因为 == 还不能在T类型上作用
                return index
            }
        }
        return nil
    }
    
}




