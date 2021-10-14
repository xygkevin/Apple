//
//  main.swift
//  IteratorPatternDemo
//
//  Created by forwardto9 on 16/3/22.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

// 迭代器模式就是顺序访问聚集中的对象，一般来说，集合中非常常见
// 一是需要遍历的对象，即聚集对象，二是迭代器对象，用于对聚集对象进行遍历访问
print("Hello, World!")
@objc protocol IteratorProtocol {
    optional func next() ->AnyObject
    optional func previous() ->AnyObject
    optional func hasNext() ->Bool
    optional func firstObject() ->AnyObject
}

@objc protocol CollectionProtocol {
    optional func iterator() ->IteratorProtocol
    optional func get(index:Int) ->AnyObject
    optional func size() ->Int
}

class ConcreteIterator:IteratorProtocol {
    private var collection:CollectionProtocol?
    private var position:Int = -1
    
    init(clt:CollectionProtocol) {
        collection = clt
    }
    
    @objc func next() -> AnyObject {
        if position < collection?.size!() {
            position++
        }
        
        return (self.collection?.get!(position))!
        
    }
    
    @objc func previous() -> AnyObject {
        if position > 0 {
            position--
        }
        
        return (self.collection?.get!(position))!
    }
    
    @objc func hasNext() -> Bool {
        if position < (self.collection?.size!())! - 1 {
            return true
        } else {
            return false
        }
    }
    
    @objc func firstObject() -> AnyObject {
        return (self.collection?.get!(0))!
    }
    
    
}

class ConcreteCollection: CollectionProtocol {
    
    private let stringArray = ["test1", "Test2", "Test3"]
    
    @objc func iterator() -> IteratorProtocol {
        return ConcreteIterator(clt: self)
    }
    
    @objc func get(index: Int) -> AnyObject {
        return stringArray[index]
    }
    
    @objc func size() -> Int {
        return stringArray.count
    }
}

let collection = ConcreteCollection()
let iterator = collection.iterator()
while iterator.hasNext!() {
    print("\(iterator.next!())")
}




