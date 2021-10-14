//
//  main.swift
//  MediatorPatterDemo
//
//  Created by forwardto9 on 16/3/22.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

print("Hello, World!")

protocol MediatorProtocol {
    func createMediator() ->Void
    func executeAllAction() -> Void
}

class User {
    private var mediator:MediatorProtocol?
    init(m:MediatorProtocol) {
        mediator = m
    }
    
    func getMediator() -> MediatorProtocol? {
        return self.mediator
    }
    
    func action() ->Void {}
}

class User1:User {
    override func action() {
        print("User1 action!")
    }
}

class User2:User {
    override func action() {
        print("User2 action!")
    }
}

class ConcretorMediator:MediatorProtocol {
    private var user1:User1?
    private var user2:User2?
    
    func createMediator() {
        user1 = User1(m: self);
        user2 = User2(m: self)
    }
    
    func executeAllAction() {
        user1?.action()
        user2?.action()
    }
    
    func getUser1() -> User1? {
        return self.user1
    }
    
    func getUser2() -> User2? {
        return self.user2
    }
}


// 中介者模式也是用来降低类类之间的耦合的，使用组合的原则
// User类统一接口，User1和User2分别是不同的对象，二者之间有关联，如果不采用中介者模式，则需要二者相互持有引用，这样二者的耦合度很高，为了解耦，引入了Mediator类，提供统一接口，MyMediator为其实现类，里面持有User1和User2的实例，用来实现对User1和User2的控制。
let mediator = ConcretorMediator()
mediator.createMediator()
mediator.executeAllAction()


