//
//  main.swift
//  CommandPatternDemo
//
//  Created by forwardto9 on 16/3/22.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

print("Hello, World!")
@objc protocol CommandProtocol {
    func execute() -> Void
    
}

class Receiver {
    func action() -> Void {
        print("Receiver get command then do action")
    }
}

class Command: CommandProtocol{
    var receiver:Receiver?
    
//    init(rcv:Receiver) {
//        receiver = rcv
//    }
    
    @objc func execute() -> Void {
        self.receiver?.action()
    }
 }

class Invoker {
    private var command:Command?
    init(cmd:Command) {
        command = cmd
    }
    
    func action() ->Void {
        command?.execute()
    }
}


// 命令模式的目的就是达到命令的发出者和执行者之间解耦，实现请求和执行分开(NSInvocation)
let receiver = Receiver()
//let command  = Command(rcv: receiver)
let command  = Command()
command.receiver = receiver

let invoker = Invoker(cmd: command)
invoker.action()

