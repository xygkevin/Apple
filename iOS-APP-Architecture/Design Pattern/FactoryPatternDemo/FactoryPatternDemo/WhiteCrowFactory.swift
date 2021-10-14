//
//  CrowFactory.swift
//  FactoryPatternDemo
//
//  Created by forwardto9 on 16/3/13.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation
class WhiteCrowFactory:CrowProviderProtocol {
    func create() -> CrowProtocol {
        return WhiteCrow()
    }
}