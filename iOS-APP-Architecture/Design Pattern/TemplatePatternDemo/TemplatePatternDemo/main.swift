//
//  main.swift
//  TemplatePatternDemo
//
//  Created by forwardto9 on 16/3/22.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

print("Hello, World!")
class AbstractCaculator {
    // 由子类覆盖
    func caculate(num1:Int, num2:Int) ->Int{return 0}
    
    
    // 私有功能性方法
    private func splitString(expresion:String, option:Character) -> [Int] {
        let array = expresion.split(separator: option)
        let intValue1 = Int(String(array[0]))
        let intValue2 = Int(String(array[1]))
        return [intValue1!, intValue2!]
        
    }
    
    // 主方法，调用被子类覆盖的方法
    func caculate(expresion:String, option:Character) ->Int {
        let array = splitString(expresion: expresion, option: option)
        return caculate(num1: array[0], num2: array[1])
    }
}


class Plus:AbstractCaculator {
    override func caculate(num1: Int, num2: Int) -> Int {
        return num1 + num2
    }
}


// 一个抽象类中，有一个主方法，再定义1...n个方法，可以是抽象的，也可以是实际的方法，定义一个类，继承该抽象类，重写抽象方法，通过调用抽象类，实现对子类的调用
let caculator = Plus()
print("Result is \(caculator.caculate(expresion: "123+234", option: "+"))")
