//
//  Model.swift
//  SwiftSyntexDemo
//
//  Created by uwei on 20/06/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

import Foundation

class Person: NSObject {
    @objc var name: String
    fileprivate var age:Int = 0
    @objc var friends: [Person] = []
    @objc var bestFriend: Person? = nil
    
    init(name: String?) {
        // 条件执行
        precondition(name != nil, "name must be not empty")
        self.name = name!
    }
    
    // 同名冲突
/*
    init(name:String!, age:Int = 0) {
        self.name = name
        self.age = age;
    }
*/
 
    
}
