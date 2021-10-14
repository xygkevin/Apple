//
//  ProviderProtocol.swift
//  FactoryPatternDemo
//
//  Created by forwardto9 on 16/3/13.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

protocol CrowProviderProtocol {
    func create() -> CrowProtocol;
}