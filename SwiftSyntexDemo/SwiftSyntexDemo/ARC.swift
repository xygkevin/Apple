//
//  ARC.swift
//  SwiftSyntexDemo
//
//  Created by uwei on 2021/2/23.
//  Copyright © 2021 Tencent. All rights reserved.
//

import Foundation

class HTMLElement {
    let name: String
    @objc let text: String?
    
    // 这个地方使用？符号标记，是为了可以在外面进行赋空值操作，从而可以标记为可以释放引用
    //  lazy修饰的属性，可以用来表明这个属性的值是不可知的，是依赖外部条件的，直到在一个实例被创建完成之后；只有被用到的时候才会被创建，这个特性可以用来实现懒加载
    lazy var asHTML: (() -> String)? = { [unowned self] in // 此处使用unowned标记，可以让闭包中不在强引用self
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
    
}

class Country {
    let name:String
    var capitalCity:City! // 这样声明，表示这个值默认是nil
    init(name:String, capitalName:String) {
        self.name = name // 到此为止，self实例就创建完毕，可以访问了，如果不是按照！符号的声明方式，下面的代码就会无法编译
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name:String
    unowned let country:Country
    init(name:String, country:Country) {
        self.name = name
        self.country = country
    }
}


func ARCDemo() -> Void {
    var heading:HTMLElement? = HTMLElement(name: "h1")
    let defaultText = "some default text"
    heading!.asHTML = {
        return "<\(heading!.name)>\(heading?.text ?? defaultText)</\(heading!.name)>"
    }
    print(heading!.asHTML!())
    heading = nil

    var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
    print(paragraph!.asHTML?() ?? "no element")
//    paragraph!.asHTML = nil //(如果asHTML被？符号标记，此处必须要释放，这样才能让paragraph充分释放)
    paragraph = nil
    
    
    
    let country = Country(name: "zhongguo", capitalName: "beijing")
    let city = City(name: "beijing", country: country)
}
