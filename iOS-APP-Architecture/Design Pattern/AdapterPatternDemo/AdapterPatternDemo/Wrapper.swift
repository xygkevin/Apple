//
//  Wrapper.swift
//  AdapterPatternDemo
//
//  Created by forwardto9 on 16/3/16.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation
class Wrapper: TargetableProtocol {
    private var source:Source?
    init(sr:Source) {
        self.source = sr
    }
    
    func method1() {
        self.source?.method1()
    }
    func method2() {
        print("Wrapper method2")
    }
}