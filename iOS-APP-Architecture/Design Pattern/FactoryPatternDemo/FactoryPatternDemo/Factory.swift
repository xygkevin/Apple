//
//  Factory.swift
//  FactoryPatternDemo
//
//  Created by forwardto9 on 16/3/13.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation
class Factory {
    init () {
    }
    
    func createBird(name:String) ->Bird? {
        
        if name == "Sparrow" {
            return Sparrow(nm: name);
        } else if name == "Parrot" {
            return Parrot(nm: name)
        } else {
            return nil
        }
    }
    
}