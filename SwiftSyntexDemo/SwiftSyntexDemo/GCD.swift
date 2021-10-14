//
//  GCD.swift
//  SwiftSyntexDemo
//
//  Created by uwei on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

import Foundation

class GCDClass {
    func m01() -> Void {
        // MARK: GCD in Swift
        let group = DispatchGroup()

        DispatchQueue.concurrentPerform(iterations: 30) { (x) in
            group.enter()
            print("x = \(x)")
            group.leave()
        }

        let result = group.wait(timeout: DispatchTime.distantFuture)
        print("result = \(result)")
    }
}


