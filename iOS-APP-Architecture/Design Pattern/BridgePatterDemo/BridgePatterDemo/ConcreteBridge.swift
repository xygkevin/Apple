//
//  ConcreteBridge.swift
//  BridgePatterDemo
//
//  Created by forwardto9 on 16/3/21.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation
class ConcreteBridge: Bridge {
    override func method() {
        self.bridgeProtocol?.method()
    }
}