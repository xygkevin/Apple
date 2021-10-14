//
//  ConcreteFlyWeight.cpp
//  FlyWeightPatternDemo
//
//  Created by forwardto9 on 16/3/21.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

#include "ConcreteFlyWeight.hpp"
#include <iostream>

ConcreteFlyWeight::ConcreteFlyWeight(string str) {
    state = str;
}

ConcreteFlyWeight::~ConcreteFlyWeight() {
    
}

void ConcreteFlyWeight::operation() {
    cout<< "FlyWeight " << state << " do operation"<<endl;
}