//
//  CarBuilder.swift
//  BuilderPatterDemo
//
//  Created by forwardto9 on 16/3/14.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation
protocol CarBuilder {
    func buildEngine() -> Void
    func buildTire() -> Void
    func buildCarFrame() -> Void
    
    func getResult()->Car?
}