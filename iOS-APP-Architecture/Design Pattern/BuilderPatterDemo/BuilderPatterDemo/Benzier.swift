//
//  Benzier.swift
//  BuilderPatterDemo
//
//  Created by forwardto9 on 16/3/15.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation
class Benzier:CarBuilder {
    private var car:Car = Car()
    
    func buildCarFrame() {
        //
        car.carFrame = CarFrame(cr: "White")
    }
    func buildTire() {
        //
        car.tire = Tire(name: "ßßßßß")
    }
    func buildEngine() {
        //
        car.engine = Engine(sz: 16)
    }
    
    func getResult() -> Car? {
        return self.car
    }

}