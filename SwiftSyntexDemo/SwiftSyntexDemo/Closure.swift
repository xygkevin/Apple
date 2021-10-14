//
//  Closure.swift
//  SwiftSyntexDemo
//
//  Created by uwei on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

import Foundation

class ClosureClass {
    var fileld01:Int = 0
    
    let swiftCallback : @convention(block) (CGFloat, CGFloat) -> CGFloat = {
        (x, y) -> CGFloat in
        return x + y
    }
    
    class func methodAutoclosure( _ completion: @autoclosure ()->Void) {
        completion()
        print("yyyy")
    }


    class func methodNoEscape( _ completion: ()->Void) {
        
        completion()
        print("yyyy")
    }

    class func methodEscape(_ completion: @escaping ()->Void) {
    }
    
    func returnValueClosure(handler:(Int)->Int) -> Int {
        let x = handler(2)
        return x
    }
    
    func call(x:Int) -> Void {
        let a = returnValueClosure { (x) -> Int in
            return x * 10
        }
        print("call = \(a)")
    }
    
}






