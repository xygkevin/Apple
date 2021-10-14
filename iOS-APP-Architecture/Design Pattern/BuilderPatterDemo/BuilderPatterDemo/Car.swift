//
//  Car.swift
//  BuilderPatterDemo
//
//  Created by forwardto9 on 16/3/14.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation
class Car {
    var engine:Engine?
    var tire:Tire?
    var carFrame:CarFrame?
    
    func show() {
        print("\(engine?.size)   \(tire?.brand)  \(carFrame?.color)")
    }
}