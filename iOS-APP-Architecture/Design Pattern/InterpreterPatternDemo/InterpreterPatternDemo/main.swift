//
//  main.swift
//  InterpreterPatternDemo
//
//  Created by forwardto9 on 16/3/22.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

print("Hello, World!")

class Context {
    
    var number1:Int?
    var number2:Int?
    
    init(num1:Int, num2:Int) {
        number1 = num1
        number2 = num2
    }
}

protocol ExpressionProtocol {
    func interpreter(ctx:Context) ->Int
}


// 对行为进行封装
class PlusExpression: ExpressionProtocol {
    func interpreter(ctx: Context) -> Int {
        return ctx.number1! + ctx.number2!
    }
}

class MinusExpression: ExpressionProtocol {
    func interpreter(ctx: Context) -> Int {
        return ctx.number1! - ctx.number2!
    }
}

// 解释器模式用来做各种各样的解释器，如正则表达式等的解释器

// 8+2-3
var plusResult = PlusExpression().interpreter(Context(num1: 8, num2: 2))
var minusResult = MinusExpression().interpreter(Context(num1: plusResult, num2: 3))
print(" 8+2-3 = \(minusResult) ")