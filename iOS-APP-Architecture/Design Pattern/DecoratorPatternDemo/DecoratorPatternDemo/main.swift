//
//  main.swift
//  DecoratorPatternDemo
//
//  Created by forwardto9 on 16/3/17.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

print("Hello, World!")

let sourceProtocol = SourceClass()
let decorator = DecoratorClass(source: sourceProtocol)
decorator.method()

