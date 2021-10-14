//
//  main.swift
//  AdapterPatternDemo
//
//  Created by forwardto9 on 16/3/16.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

print("Hello, World!")

let target:TargetableProtocol = Adapter()
target.method1()
target.method2()

let source = Source()
let wrapper = Wrapper(sr: source)
wrapper.method1()
wrapper.method2()
