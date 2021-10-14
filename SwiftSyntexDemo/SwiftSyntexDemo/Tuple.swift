//
//  Tuple.swift
//  SwiftSyntexDemo
//
//  Created by uwei on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

import Foundation

class TupleClass {
    class func m0() -> Void {
        let tuple1 = (27, "uwei")
        let tuple2 = (28, "yuan")
        let tuple3 = (1, "X", "12")

        if tuple1 < tuple2 {
            print("<")
        }
        let tuple4 = (age:12, name:"uwei")
        print("name is \(tuple4.name)")

    }
    
    deinit {
        print("Tuple deinit")
    }
}
