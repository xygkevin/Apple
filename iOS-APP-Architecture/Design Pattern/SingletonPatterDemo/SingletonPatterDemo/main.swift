//
//  main.swift
//  SingletonPatterDemo
//
//  Created by forwardto9 on 16/3/14.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

print("Hello, World!")

let instance = Singleton.shareInstance
instance.name = "test"


let instance1 = Singleton.shareInstance
print(instance1.name)