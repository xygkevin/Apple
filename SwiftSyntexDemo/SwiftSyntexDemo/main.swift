//
//  main.swift
//  SwiftSyntexDemo
//
//  Created by uwei on 9/29/15.
//  Copyright © 2015 Tencent. All rights reserved.
//

import Foundation

ARCDemo()

exit(0)
// 访问 OC中的枚举
print(EnumDemoX)
OCClass().info(name: "uwei")

if #available(OSX 10.15.0, *) {
    opaqueDemo()
} else {
    // Fallback on earlier versions
}

TupleClass.m0()
ClosureClass().call(x: 10)

SwiftFunctions()
SwiftTypes()

@dynamicCallable // Swift 5 可以调用对象实例就像调用一个可以带有任意数量的函数一样,
struct TelephoneExchange {
    // 参数必须遵循协议： ExpressibleByArrayLiteral
    func dynamicallyCall(withArguments nums:[Int]) {
        if nums == [1,1,0] {
            print("police number")
        } else {
            print("unrecoginzed number")
        }
    }
    
    // 参数必须遵循协议： ExpressibleByDictionaryLiteral， Key必须要遵循协议：ExpressibleByStringLiteral
    func dynamicallyCall(withKeywordArguments pairs: KeyValuePairs<String, Int>) -> String {
        return pairs.map{lable, count in
            repeatElement(lable, count: count).joined(separator: "-")
        }.joined(separator: "|")
    }
    
    // 此方法就不能将实例对象模拟成函数调用，因为不遵循上述要求
    func dynamicallyCall(withArguments nums:Int) {
        print(nums)
    }
}

let telEx = TelephoneExchange()
//telEx([1,1,10]) // error , 参数类型匹配不到
telEx(1,1,10)
telEx(1,1,0)

//telEx("test") // error , 参数类型匹配不到
//telEx(A:1, B:"") // error , 参数类型匹配不到

print(telEx(A:1, B:2))

telEx.dynamicallyCall(withArguments: 1)



let predicateDemo = PredicateDemo()
predicateDemo.testPredicate()


@available(iOS 10, *)
func testiOS10() -> Void {
    print("10")
}

@available(macOS, deprecated:10, message:"this is a deprecated protocol")
protocol MyProtocol {
    // protocol definition
}



protocol MyRenamedProtocol {
    // protocol definition
}

@available(iOS, unavailable, renamed: "MyRenamedProtocol")
class protocolTest: MyProtocol {
}


class OverLoading {
    func overload(p1:String) -> Void {
        print(p1)
    }
    
    @discardableResult
    func overload() -> Bool {
        return false
    }
}

let overload1 = OverLoading()
overload1.overload() // no warning
overload1.overload(p1: "overload")


var stackInt = Stack(items: [1,2,4])
print(stackInt.count)
stackInt.append(3)
print(stackInt.count)
print(stackInt[2])
stackInt.pop()
print(stackInt.count)
for it in stackInt.items {
    print(it)
}

var stackString = Stack(items: ["string1", "string2"])
stackString.append("string3")
for string in stackString.items {
    print(string)
}

// 针对函数泛型，编译器对类型进行推断
// 由于p2传入了2，编译器已经将T2推断为Int，p4就只能是Int
//stackString.find(p1: 1, p2: 2, p3: "test generic", p4: "?")
GenericUtils.find(p1: 1, p2: 2, p3: "test generic", p4: 4)
GenericUtils.find(p1: (2, 7, 9), p2: 2)
let stackInt1 = Stack(items: [5,2])
let indexx = GenericUtils.findIndex(target: stackInt, in: [stackInt1, stackInt])
print("find \((indexx != nil) ? indexx! : 0 )")


// Now all your tasks have finished

// MARK: - String
StringDemo.demo()

func swapTest(al a:inout Int, bl b:inout Int) {
    let temp = a
    a = b
    b = temp
}

var atest = 10
var btest = 11
swapTest(al: &atest, bl: &btest)
print("\(atest), \(btest)")

public class AccessClass {
    open var openName:String = ""
    public var publicName:String = ""
    private var privateName:String = ""
    fileprivate var fileprivateName:String = ""
    internal var internalName:String = ""
}


var ac = AccessClass()
ac.fileprivateName = "filePrivate"
ac.internalName    = "internal"
ac.openName        = "open"
ac.publicName      = "public"

class ClassA {
    var accc = AccessClass()
    var x = 0
    var handlers:[()->Void] = []
    
    required init (x:Int) {
        self.x = x
    }
    
    
    // 此属性用于提醒编译器，不需要对未使用返回值的调用发出警告
    // @discardableResult
    func test() -> Int {
        accc.fileprivateName = ""
        return 0
    }
    
    
//    func test1()->Never {
//        print("test1")
//    }
}


let a = ClassA(x: 0)
let b = ClassA(x: 0)
if a === b {
    print("===")
} else {
    print("!==")
}
a.test()
if type(of: a) === type(of: b) {
    print("===")
} else {
    print("!==")
}

let metaType:ClassA.Type = ClassA.self
let instance = metaType.init(x: 10)
print(instance.x)

var optionalString:String?

optionalString = String(9089)


print(optionalString!)
if let string = optionalString {
    print(" numer \(string)")
} else {
}

if let lastName = Int("123"), let familyName = Int("456") , lastName < familyName {
    print("\(lastName) + \(familyName)")
}



enum Number {
    case integer(Int)
    case real(Double)
}

let f = Number.integer
let evenInts:[Number] = [2, 10].map(f)
print(evenInts)



func neverRetuen() -> Never {
    fatalError("Something very, very bad happened")
}

var weigh = 1
guard weigh > 0 else {
    neverRetuen()
}




var index = 0
label :while index < 10 {
    print("*")
    if index == 8 {
    break label
    }
    index += 1
}


class SubNSObject: NSObject {
    var name:String?
    func  showName(_ prefix:String) -> Void {
    print(prefix+name!)
    }
    
    
}


func ==(p1:SubNSObject, p2:SubNSObject) -> Bool {
    var result = false
    if p1.name == p2.name {
        result = true
    }
    
    return result
}


infix operator ====
//infix operator ===={}
func ==== (p1:SubNSObject, p2:SubNSObject) -> Bool {
    var result = false
    if p1.name == p2.name {
    result = true
    }
    
    return result
}
let s1 = SubNSObject()
//p1.name = "vv"
let s2 = SubNSObject()
//p2.name = "vvv"
let sResult = (s1 ==== s2)
print(sResult)


//precompile error
//let result = tuple1 > tuple3

class UPoint {
    var x:Float?
    var y:Float?
    init(x:Float, y:Float){
        self.x = x
        self.y = y
    }
}
// only for file scope
// first declare the override operator
//infix operator +- {associativity right precedence 0} //不再推荐使用
infix operator +-:AdditionPrecedence // 新的方式，需要知道precedence group 参照：https://developer.apple.com/documentation/swift/swift_standard_library/operator_declarations
// then complemention
func +-(p1:UPoint, p2:UPoint) -> UPoint {
    return UPoint(x: p2.x! - p1.x!, y: p2.y! + p1.y!)
}



var p1 = UPoint(x: 1, y: 2)
var p2 = UPoint(x: 3, y: -1)

let p3 = p1 +- p2


//#if swift(>=3.0)
//print("3.0")
//#else
//print("low")
//#endif





let gabrielle = Person(name: "Gabrielle")
let jim = Person(name: "Jim")
let yuanyuan = Person(name: "Yuanyuan")
gabrielle.friends = [jim, yuanyuan]
gabrielle.bestFriend = yuanyuan
// 使用let 对一个optional的对象取值的步骤是：1.先询问optional对象是不是空，2如果是空，在不进行赋值，且跳过if；如果不是空，则进行unwrap操作（等同于使用 ! 操作），并进行赋值操作
if let name = gabrielle.bestFriend?.name {
    print(name)
}

//MARK: Runtime in Swift
// #selector
print ( gabrielle.value(forKeyPath: #keyPath(Person.bestFriend.name)) as Any )


func functionWithDefaultValue(p:Int  = 100) -> Int {
    return p + 1
}

print( functionWithDefaultValue() )
print(functionWithDefaultValue(p: 2))

func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
    total += number
    }
    return total / Double(numbers.count)
}

print(arithmeticMean(1,3,4))

func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
var mathFunction: (Int, Int) -> Int = addTwoInts
print("Result: \(mathFunction(2, 3))")

func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}

printMathResult(addTwoInts, 3, 5)

func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int { return input + 1 }
    func stepBackward(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}
var currentValue = -4
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
// moveNearerToZero now refers to the nested stepForward() function
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")


func minMax(array: [Int]) -> (min: Int, max: Int)? {
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
        currentMin = value
    } else if value > currentMax {
        currentMax = value
        }
    }
    return (currentMin, currentMax)
}

if let bounds = minMax(array: [8, -6, 2, 109, 3, 71]) {
    print("min is \(bounds.min) and max is \(bounds.max)")
}

class SomeClass: NSObject {
    @objc let property: String
    @objc(xxxx)
    var myProperty:String = ""
    @objc(doSomethingWithInt:)
    func doSomething(xx x: Int) { }
    
    init(property: String) {
        self.property = property
    }
}

let selectorForMethod = #selector(SomeClass.doSomething(xx:))
let selectorForPropertyGetter = #selector(getter: SomeClass.property)
let selectorForPropertySetter = #selector(setter: SomeClass.myProperty)


// MARK:- 高阶函数的使用
let intArray = [1,2,4,8,16]
let sIntArray = intArray.map { $0*$0 }
print(sIntArray)
// sIntArray.map({print($0)})
let fIntArray = sIntArray.filter({$0 > 4})
print(fIntArray)

let addString: (String, Int) -> String = {
        return $0 + String($1) + ","
}

let sumArray = fIntArray.reduce(0, +)
print(sumArray)
let stringArray = fIntArray.reduce("", {return $0 + "," + String($1)})
//let stringArray = fIntArray.reduce("", combine: {return String($0)})
print(stringArray)




// MARK:- 面向函数式编程
let clourse:(Int) -> Int = { x in
    return x + 2
}
func testClourse(str:String, clourse:(Int)->Int) -> String {
    let result = clourse(98)
    var string = ""
    if result > 98 {
    string = str + " " + String(result)
    }
    return string
}

// MARK:- 科里化函数
func curryTestClourse(str:String)->((Int)->Int) -> String {
    return { (intClourse: (Int) -> Int) -> String in
    let result = intClourse(9)
    var string = ""
    if result > 98 {
    string = str + " " + String(result)
} else {
    string = str + " " + "error"
    }
    return string
    }
}

let testClourseResult = testClourse(str: "hello", clourse:clourse)
print(testClourseResult)
let testCurryTestClourseFirst = curryTestClourse(str: "world")
let testCurryTestClourseResult = testCurryTestClourseFirst(clourse)
print(testCurryTestClourseResult)

class DataImporter {
    /*
     DataImporter is a class to import data from an external file.
     The class is assumed to take a non-trivial amount of time to initialize.
     */
    var fileName = "data.txt"
    init() {
        print("DataImporter Inited!")
    }
    // the DataImporter class would provide data importing functionality here
}

class DataManager {
        lazy var importer = DataImporter()
        var data = [String]()
        // the DataManager class would provide data management functionality here
}

let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
print(manager.data)
print(manager.importer.fileName)







func testFunctionParams1(p1:String, p2:Int) -> Void {
    print("\(p1), \(p2)")
}

func testFunctionParams(label1 p1:String, label2 p2:Int) -> Void {
    print("\(p1), \(p2)")
}



testFunctionParams(label1: "12345", label2: 678)


#sourceLocation(file:"File.swift", line:20)

print(#function)
print(#file)
print(#line)
print(#column)

displayInfo()






#sourceLocation()

#if os(iOS)
    print("iOS")
#elseif os(tvOS)
    print("tv X")
#elseif os(OSX)
    print("OS X")
    #else
    print("unknown")
#endif

#if arch(x86_64)
    print("Mac")
    #else
    print("other")

#endif

#if swift(>=5)
print("Swift5")
#elseif swift(<5) && swift(>=4.1)
print("Swift4.2")
#else
print("Swift lower!")
#endif


@dynamicMemberLookup
struct DynamicStruct {
    let dictionary = ["someDynamicMember": 325,
                      "someOtherMember": 787]
    // must be implementation
    subscript(dynamicMember member: String) -> Int {
        return dictionary[member] ?? 1054
    }
}
let s = DynamicStruct()

// Using dynamic member lookup
let dynamic = s.someOtherMember
print(dynamic)
// Prints "325"

// Calling the underlying subscript directly
let equivalent = s[dynamicMember: "someDynamicMember"]
print(dynamic == equivalent)


let md5String = md5(string: "uwei")
print(md5String)
print(md5(string: md5String))
