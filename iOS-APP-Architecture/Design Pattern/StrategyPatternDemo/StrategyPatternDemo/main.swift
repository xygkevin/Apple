//
//  main.swift
//  StrategyPatternDemo
//
//  Created by forwardto9 on 16/3/22.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

print("Hello, World!")

//策略模式定义了一系列算法，并将每个算法封装起来，使他们可以相互替换，且算法的变化不会影响到使用算法的客户

// 将对外的接口封装成一个协议
protocol CaculateProtocol {
    func caculate(expresion:String) ->Int
}

// 提供另外的操作，与模式无关
class Operation {
    func splitString(expresion:String, option:Character) -> [Int] {
        let array = expresion.characters.split(option)
        let intValue1 = Int(String(array[0]))
        let intValue2 = Int(String(array[1]))
        return [intValue1!, intValue2!]
        
    }
}


// 将算法封装成一个类
class Plus:Operation, CaculateProtocol {
    func caculate(expresion: String) ->Int {
        let array = splitString(expresion, option: "+")
        return array[0] + array[1]
    }
}


class Minus:Operation, CaculateProtocol {
    func caculate(expresion: String) -> Int {
        let array = splitString(expresion, option: "-")
        return array[0] - array[1]
    }
}


let caculatorPlus = Plus()
let resultPlus = caculatorPlus.caculate("2+8")
print("Plus result is \(resultPlus)")

let caculatorMinus = Minus()
let resultMinus = caculatorMinus.caculate("2-8")
print("Minus result is \(resultMinus)")






