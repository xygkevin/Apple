//
//  DecoratorClass.swift
//  DecoratorPatternDemo
//
//  Created by forwardto9 on 16/3/17.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation


//动态的给一个类的方法的执行，添加额外的功能或者是处理步骤：就是调用一个方法之前或者是之后多做一些事情
class DecoratorClass {
    private var sourceProtocol:SourceProtocol?
    init(source:SourceProtocol) {
        self.sourceProtocol = source
    }
    
    func method() {// 同名
        print("Decorator before")
        self.sourceProtocol?.method()
        print("Decorator End")
    }
}