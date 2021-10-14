//
//  Enum.swift
//  SwiftSyntexDemo
//
//  Created by uwei on 2021/1/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

import Foundation

// MARK:  Enum
//enum Color:Int { // 指定类型
enum Color { // 未指定类型
//    case red, black
    case red, black, blue
    func colorDescription() -> String {
        switch self {
        case .red:
            return "RED"
        case .black:
            return "BLACK"
//        default:
        @unknown default: //编译时期会提醒有未覆盖的case需要添加
            return ("color is unknown")
        }
    }
}


enum ServerResponse {
    case result(String, String)
    case failure(String)
}

class EnumClass {
    func m0() -> Void {
        //print(Color.black.rawValue)
        print(Color.black)
        print(Color.black.colorDescription())
        print(Color.blue.colorDescription())
        
        let sucess = ServerResponse.result("6:00am", "9:00pm")
        let failuer = ServerResponse.failure("Out of service")
        print(sucess)
        switch sucess {
        case let .result(sunrise, sunset):
            print("sunrice is at \(sunrise), sunset is at \(sunset)")
        case let .failure(reason):
            print("failure reason is \(reason)")
        }
    }
}
