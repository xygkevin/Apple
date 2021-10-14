//
//  Director.swift
//  BuilderPatterDemo
//
//  Created by forwardto9 on 16/3/14.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation
class Director {
    private var carBuilder:CarBuilder?
    
    init(builder:CarBuilder) {
        carBuilder = builder;
    }
    
    func createCar() {
        carBuilder?.buildCarFrame()
        carBuilder?.buildEngine()
        carBuilder?.buildTire()
    }
}