//
//  Adapter.swift
//  AdapterPatternDemo
//
//  Created by forwardto9 on 16/3/16.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation
class Adapter: Source, TargetableProtocol {
//    Targetable接口的实现类就具有了Source类的功能
    func method2() {
        print("Targetable method2")
    }
}