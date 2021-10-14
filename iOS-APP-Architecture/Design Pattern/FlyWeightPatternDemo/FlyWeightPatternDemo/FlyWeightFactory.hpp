//
//  FlyWeightFactory.hpp
//  FlyWeightPatternDemo
//
//  Created by forwardto9 on 16/3/21.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

#ifndef FlyWeightFactory_hpp
#define FlyWeightFactory_hpp

#include <stdio.h>
#include <map>
#include <string>
#include "FlyWeight.hpp"
using namespace std;

class FlyWeightFactory {
    private :
    map<string, FlyWeight*> m_mpFlyWeight;
    
    public :
    FlyWeightFactory();
    ~FlyWeightFactory();
    FlyWeight* getFlyWeight(string str);
};


#endif /* FlyWeightFactory_hpp */
