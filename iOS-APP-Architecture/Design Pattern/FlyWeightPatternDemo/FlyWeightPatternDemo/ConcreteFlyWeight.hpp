//
//  ConcreteFlyWeight.hpp
//  FlyWeightPatternDemo
//
//  Created by forwardto9 on 16/3/21.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

#ifndef ConcreteFlyWeight_hpp
#define ConcreteFlyWeight_hpp

#include <stdio.h>
#include <string>
#include "FlyWeight.hpp"
using namespace std;

class ConcreteFlyWeight:public FlyWeight{
public:
    ConcreteFlyWeight(string str);
    ~ConcreteFlyWeight();
    virtual void operation();
private:
    string state;
};

#endif /* ConcreteFlyWeight_hpp */
