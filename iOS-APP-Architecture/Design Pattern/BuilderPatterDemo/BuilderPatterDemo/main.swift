//
//  main.swift
//  BuilderPatterDemo
//
//  Created by forwardto9 on 16/3/14.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

print("Hello, World!")

//let bmwBuidler:CarBuilder = BMW();
let bmwBuidler:CarBuilder = Benzier();
let director = Director(builder: bmwBuidler)
director.createCar()
bmwBuidler.getResult()?.show()


