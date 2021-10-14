//
//  main.swift
//  VisitorPatternDemo
//
//  Created by forwardto9 on 16/3/22.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

print("Hello, World!")


@objc protocol SubjectProtocol {
    func getSubject()->String
    func accept(visitor:VisitorProtocol)
}


@objc protocol VisitorProtocol {
    
    func visit(subject:SubjectProtocol)
}

class Vistor:VisitorProtocol {
    // 对数据的操作，可变部分
    @objc func visit(subject: SubjectProtocol) {
        print("Visite the subject \(subject.getSubject())")
    }
}

class Subject:SubjectProtocol {
    // 数据部分,固定部分
    @objc func getSubject() -> String {
        return "X"
    }
    
    @objc func accept(visitor: VisitorProtocol) {
        visitor.visit(self)
    }
}

//访问者模式把数据结构和作用于结构上的操作解耦合，使得操作集合可相对自由地演化。访问者模式适用于数据结构相对稳定算法又易变化的系统
let visitor = Vistor()
let subject = Subject()
// 想对数据如何操作，只要给accept方法一个不一样的visitor即可
// 所以，访问者模式使得算法操作增加变得容易
subject.accept(visitor)