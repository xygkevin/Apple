//
//  Parrot.swift
//  FactoryPatternDemo
//
//  Created by forwardto9 on 16/3/13.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation
class Parrot: Bird {
    init(nm:String) {
        super.init()
        self.name = nm
    }
}