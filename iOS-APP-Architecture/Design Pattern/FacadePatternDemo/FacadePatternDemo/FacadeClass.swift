//
//  FacadeClass.swift
//  FacadePatternDemo
//
//  Created by forwardto9 on 16/3/17.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

// 为系统的很多零部件的同一样的接口提供统一的接口封装
class FacadeClass {
    private var cpu:CPU!
    private var disk:Disk!
    private var memory:Memory!
    
    init() {
        self.cpu = CPU()
        self.disk = Disk()
        self.memory = Memory()
    }
    
    func startup() {
        self.cpu.startup()
        self.disk.startup()
        self.memory.startup()
    }
    
    func shutdown() {
        self.cpu.shutDown()
        self.disk.shutDown()
        self.memory.shutDown()
    }
}