//
//  Error.swift
//  SwiftSyntexDemo
//
//  Created by uwei on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

import Foundation

enum ErrorEnum:Error {
    case error1
    case error2
}

class ErrorClass {
        // MARK: Error Handling
        @discardableResult // 取消返回值未用到的编译警告
        func testThrowError(result num:Int?) throws ->String? {
            defer { // defer代码块类似OC中try catch finally块中的finally块，始终是函数中最后执行的，可以用于还原设置、清理现场等场景
                print("this is like exceeded finally")
            }
            guard Int(num!) > 0 else {
            print("num <= 0")
            
            throw ErrorEnum.error1
            }
            print("num = \(String(describing: num))")
            return String(describing: num)
        }


        // rethrows only for parameters throw error
        func testRethrowError(callback:() throws -> Void) rethrows {
            try callback()
        }


        
    func m0() -> Void {
        do {
            try? testThrowError(result: -1)
        } catch ErrorEnum.error1 {
            print("catch error!")
        }
        // try?，当方法调用出现throw的时候，方法的返回值是nil，throw出的error会被取消
        let testThrowErrorResult = ((try? testThrowError(result: -1)) as String??)
        print(testThrowErrorResult as Any )
    }
}
