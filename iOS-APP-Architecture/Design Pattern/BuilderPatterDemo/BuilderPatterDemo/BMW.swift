//
//  BMW.swift
//  BuilderPatterDemo
//
//  Created by forwardto9 on 16/3/15.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation
class BMW: CarBuilder {
    private var car:Car = Car()
    
    func buildCarFrame() {
        //
        car.carFrame = CarFrame(cr: "Blue")
    }
    func buildTire() {
        //
        car.tire = Tire(name: "X5")
    }
    func buildEngine() {
        //
        car.engine = Engine(sz: 8)
    }
    
    func getResult() -> Car? {
        return self.car
    }
}