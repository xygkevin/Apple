//
//  main.swift
//  FactoryPatternDemo
//
//  Created by forwardto9 on 16/3/13.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

print("Hello, World!")



let f = Factory()
let b:Bird? = f.createBird(name: "Parrot")
b?.Sound();


// 将参数去掉，改为类名(工厂类名，实现类名)
let provider = WhiteCrowFactory()
let crow = provider.create()
crow.Sound();

let provider1 = BlackCrowFactory()
let crow1     = provider1.create();
crow1.Sound();



/*
var i = 0
while (true) {
    let f = Factory()
    if i == 0 {
        let b:Bird? = f.createBird("Parrot")
        b?.Sound();
        i = 1
    }
    if i == 1 {
        let b:Bird? = f.createBird("Sparrow")
        b?.Sound();
        i = 0
    }
}
*/


