//
//  FlyWeightFactory.cpp
//  FlyWeightPatternDemo
//
//  Created by forwardto9 on 16/3/21.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

#include "FlyWeightFactory.hpp"
#include "ConcreteFlyWeight.hpp"
#include <iostream>
FlyWeightFactory::FlyWeightFactory() {
    
}

FlyWeightFactory::~FlyWeightFactory() {
    
}

FlyWeight* FlyWeightFactory::getFlyWeight(string str) {
    map<string, FlyWeight *>::iterator itr = m_mpFlyWeight.find(str);
    if (itr == m_mpFlyWeight.end()) {
        FlyWeight *fw = new ConcreteFlyWeight(str);
        m_mpFlyWeight.insert(make_pair(str, fw));
        return fw;
    } else {
        cout<< "Already exist one" <<endl;
        return itr->second;
    }
}