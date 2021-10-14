//
//  main.swift
//  InterfaceOrientedProgram
//
//  Created by uweiyuan on 2020/3/26.
//  Copyright © 2020 Tencent. All rights reserved.
//


/** 首阶
 现在我们要开发一个应用，模拟移动存储设备的读写，即计算机与U盘、MP3、移动硬盘等设备进行数据交换。
 上下文（环境）：已知要实现U盘、MP3播放器、移动硬盘三种移动存储设备，要求计算机能同这三种设备进行数据交换
 */
/** 进阶
 以后可能会有新的第三方的移动存储设备，所以计算机必须有扩展性，能与目前未知而以后可能会出现的存储设备进行数据交换
 */


import Foundation

print("Hello, World!")

/// 抽象类和接口的区别在于使用动机。
/// 使用抽象类是为了代码的复用
/// 使用接口的动机是为了实现多态性

protocol IMobileStorage {
    func read() -> Void
    func write() -> Void
}

class MP3Player: IMobileStorage {
    func write() {
        print("MP3 write")
    }
    
    func read() {
        print("PM3 read")
    }
}

class FlashDisk: IMobileStorage {
    func read() {
        print("Flash read")
    }
    func write() {
        print("Flash write")
    }
}

class MobileHardDisk: IMobileStorage {
    func read() {
        print("Hard disk read")
    }
    func write() {
        print("Hard disk write")
    }
}

class Computer {
    var storage:IMobileStorage?
    func readData() -> Void {
        storage?.read()
    }
    func writeData() -> Void {
        storage?.write()
    }
}

let mp3 = MP3Player()
let flash = FlashDisk()
let mobileHard = MobileHardDisk()
let computer = Computer()
computer.storage = mp3
computer.readData()
computer.writeData()

computer.storage = flash
computer.readData()
computer.writeData()

computer.storage = mobileHard
computer.readData()
computer.writeData()


class SuperStorage {
    func r() -> Void {
        print("Super read")
    }
    func w() -> Void {
        print("Super write")
    }
}

class SuperAdapter: IMobileStorage {
    var storage:SuperStorage?
    func read() {
        storage?.r()
    }
    
    func write() {
        storage?.w()
    }
}

let superStorage = SuperStorage()
let adapter = SuperAdapter()
adapter.storage = superStorage
computer.storage = adapter
computer.readData()
computer.writeData()


