//
//  Opaque.swift
//  SwiftSyntexDemo
//
//  Created by uwei on 2021/2/23.
//  Copyright © 2021 Tencent. All rights reserved.
//

import Foundation
//  不透明类型仅用在函数或者是方法的返回值上，用以隐藏返回值的具体类型信息
//  解决了不必要类型的转换或者是暴露(逻辑代码使用模块接口时)

//  与Protocol类型返回值的区别是：返回类型是否持有类型标识
//  虽然不透明，但是是具体的某一个类型，尽管调用者看不到
//  Protocol返回类型对存储基础类型提供了更多的灵活性
//  Opaque返回类型则提供了更明确的类型保证

protocol Shape {
    func draw() -> String
}

struct Triangle: Shape {
    var size:Int
    func draw() -> String {
        var result  = [String]()
        for length in 1...size {
            result.append(String(repeating: "*", count: length))
        }
        return result.joined(separator: "\n")
    }
}

struct FlippedShape<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}

struct JoinedShape<T: Shape, U: Shape>: Shape {
    var top: T
    var bottom: U
    func draw() -> String {
        return top.draw() + "\n" + bottom.draw()
    }
}

struct Square: Shape {
    var size:Int
    func draw() -> String {
        let line = String(repeating: "*", count: size)
        let result = Array<String>(repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}


// This implementation uses two triangles and a square, but the function could be rewritten to draw a trapezoid in a variety of other ways without changing its return type.
@available(OSX 10.15.0, *)
func makeTrapezoid() -> some Shape {
    let top = Triangle(size: 2)
    let middle = Square(size: 2)
    let bottom = FlippedShape(shape: top)
    let trapezoid = JoinedShape(
        top: top,
        bottom: JoinedShape(top: middle, bottom: bottom)
    )
    return trapezoid
}

@available(OSX 10.15.0, *)
func flip<T: Shape>(_ shape:T) -> some Shape {
    return FlippedShape(shape: shape)
}

//  protocol types
func protoFlip<T: Shape>(_ shape:T) -> Shape {
    return FlippedShape(shape: shape)
}

@available(OSX 10.15.0, *)
func join<T: Shape, U: Shape>(_ top: T, _ bottom: U) -> some Shape {
    JoinedShape(top: top, bottom: bottom)
}
@available(OSX 10.15.0, *)
func opaqueDemo() -> Void {
    let smallTriangle = Triangle(size: 3)
    let opaqueJoinedTrangles = join(smallTriangle, flip(smallTriangle))
    print(opaqueJoinedTrangles.draw())
}
