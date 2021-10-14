//
//  Animal.swift
//  FactoryPatternDemo
//
//  Created by forwardto9 on 16/3/13.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation


class Bird {
    
    init () {
       print("Super Class")
    }
    
    var name:String = ""
    func Sound()->Void {
        print("I'm a \(self.name)")
    }
}