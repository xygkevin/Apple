//
//  main.swift
//  ChainOfResPatternDemo
//
//  Created by forwardto9 on 16/3/22.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

print("Hello, World!")

@objc protocol HandlerProtocol {
    optional func operation() ->Void
}

class Handler {
    var handlerProtocol:HandlerProtocol?
}

// 继承，协议结合
class ConcretorHandler:Handler, HandlerProtocol {
    private var handlerName:String?
    init(name:String) {
        handlerName = name
    }
    
    @objc func operation() {
        print("\(handlerName!) deal!")
        if (self.handlerProtocol != nil) {
            self.handlerProtocol?.operation!()
        }
    }
    
}

let handler = ConcretorHandler(name: "Hander")
let handler1 = ConcretorHandler(name: "Hander1")
let handler2 = ConcretorHandler(name: "Hander2")

// 责任链模式，有多个对象，每个对象持有对下一个对象的引用，这样就会形成一条链，请求在这条链上传递，直到某一对象决定处理该请求。但是发出者并不清楚到底最终那个对象会处理该请求，所以，责任链模式可以实现，在隐瞒客户端的情况下，对系统进行动态的调整
handler1.handlerProtocol = handler2
handler.handlerProtocol  = handler1
handler.operation()
