//
//  Singleton.swift
//  SingletonPatterDemo
//
//  Created by forwardto9 on 16/3/14.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation
class Singleton {
    var name:String?
    static let shareInstance = Singleton()
}