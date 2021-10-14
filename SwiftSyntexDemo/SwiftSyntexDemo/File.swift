//
//  File.swift
//  SwiftSyntexDemo
//
//  Created by uwei on 9/20/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

import Foundation



class FileA {
    
    // 这样的做法会导致循环访问
/*
    static var property1:Int {
        set {
            self.property1 = newValue
        }
        get {
            return self.property1
        }
    }
    */
    static var number:Int = 0
    static var property1:Int {
        set {
            number = newValue + 10000
        }
        get {
            return number
        }
    }
    
    static var property2 = "X"
    // class 声明的属性，一般用于computed property，可以让子类来重写子类的逻辑
    class var property3:String {
        return "333"
    }
    
    // 使用final，让属性，方法，subscript都不可以被override
    // 也可以使用final修饰 class，标识不让继承
    final func cannotOverrideMethod() -> Void {
        print("not allowed to be overrided")
    }
    func canOverrideMethod() -> Void {
        print("allow to be overrided")
    }
}


class FileB: FileA {
    // static 声明的 type property 是不允许重写的
//    override static var property1:Int = 10
    // class 声明的 type property 是允许重写的
    override class var property3:String {
        return "2222"
    }
    
    override func canOverrideMethod() {
        print("sub class completition")
    }
    
//    override func cannotOverrideMethod() {
//
//    }
    
    
    lazy var lazyProperty:String = {
        if self.lazyProperty.count > 0 {
            let x = "123"
            let y = "456"
            print("fuck");
            return x + y
        }
        return self.lazyProperty;
    }()
    
}




func displayInfo() -> Void {
    print("This a test message")
    print(FileB.property2)
    print(FileB().lazyProperty)
    print(FileB().lazyProperty)
    FileA.property1 = 1
    print(FileA.property1)
}

public class TestFileName {
    let acc = AccessClass()
    public func setV() -> Void {
        acc.internalName = "interal"
        acc.openName     = "open"
        acc.publicName   = "public"
    }
    @warn_unqualified_access
    func min() -> Void {
    }
}

var testFileName = TestFileName()



