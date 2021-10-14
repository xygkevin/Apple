//
//  main.cpp
//  FlyWeightPatternDemo
//
//  Created by forwardto9 on 16/3/21.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

#include <iostream>
#include "ConcreteFlyWeight.hpp"
#include "FlyWeightFactory.hpp"
#include "FlyWeight.hpp"

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    
    FlyWeightFactory *factory = new FlyWeightFactory();
    FlyWeight *fw1 = factory->getFlyWeight("One");
    fw1->operation();
    FlyWeight *fw2 = factory->getFlyWeight("Two");
    fw2->operation();
    
    
    FlyWeight *fw3 = factory->getFlyWeight("One");
    fw3->operation();
    
    free(factory);
    
    return 0;
}
