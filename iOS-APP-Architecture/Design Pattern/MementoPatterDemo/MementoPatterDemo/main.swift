//
//  main.swift
//  MementoPatterDemo
//
//  Created by forwardto9 on 16/3/22.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

print("Hello, World!")
class Memento {
    var value:String?
    init(v:String) {
        self.value = v
    }
}

class Original {
    var value:String?
    init(v:String) {
        self.value = v
    }
    
    func createMemento() ->Memento {
        return Memento(v: self.value!)
    }
    
    func restoreMemento(meme:Memento) ->Void {
        value = meme.value
    }
}


class Storage {
    var memento:Memento?
    init(mm:Memento) {
        memento = mm
    }
}

// 主要目的是保存一个对象的某个状态，以便在适当的时候恢复对象
// Original类是原始类，里面有需要保存的属性value及创建一个备忘录类，用来保存value值。Memento类是备忘录类，Storage类是存储备忘录的类，持有Memento类的实例

let original = Original(v: "Original!")
let storage = Storage(mm: original.createMemento())
print("\(original.value!)")
original.value = "Changed!"
print("\(original.value!)")

original.restoreMemento(storage.memento!)
print("\(original.value!)")