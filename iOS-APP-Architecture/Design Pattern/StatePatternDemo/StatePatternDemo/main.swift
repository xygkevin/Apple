//
//  main.swift
//  StatePatternDemo
//
//  Created by forwardto9 on 16/3/22.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

print("Hello, World!")

class State {
    var value:String?
    
    func method1() ->Void {
        print("method1")
    }
    
    func method2() ->Void {
        print("method2")
    }
    
    func method() ->Void {
        print("other method")
    }
}

class Context {
    private var state:State?
    init(st:State) {
        state = st
    }
    
    func method() {
        if state?.value == "1" {
            state?.method1()
        } else if state?.value == "2" {
            state?.method2()
        } else {
            state?.method()
        }
    }
}


//核心思想就是：当对象的状态改变时，同时改变其行为

let state = State()
let context = Context(st:state)

state.method()
state.value = "1"
context.method()
state.value = "2"
context.method()
