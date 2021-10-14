//
//  PredicateDemo.swift
//  SwiftSyntexDemo
//
//  Created by uwei on 20/06/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

// link: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795


import Foundation

fileprivate let firstNamekey = "firstName"
fileprivate let lastNamekey = "lastName"
fileprivate let agekey = "age"

class PersonDemo: NSObject,NSCoding {
    @objc var firstName: NSString
    @objc var lastName: NSString
    @objc var age: Int
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName as NSString
        self.lastName = lastName as NSString
        self.age = Int(truncating: NSNumber(value: age))
    }
    
    override var description: String {
        return "\(firstName) \(lastName)"
   }
    
    override func value(forUndefinedKey key: String) -> Any? {
        print(key)
        return "age"
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.firstName = aDecoder.decodeObject(forKey: firstNamekey) as! NSString
        self.lastName  = aDecoder.decodeObject(forKey: lastNamekey) as! NSString
        self.age       = Int(truncating: aDecoder.decodeObject(forKey: agekey) as! NSNumber)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.firstName, forKey: firstNamekey)
        aCoder.encode(self.lastName, forKey: lastNamekey)
        aCoder.encode(NSNumber(value: self.age), forKey: agekey)
    }
}

let alice = PersonDemo(firstName: "Alice", lastName: "Smith", age: 24)
let bob = PersonDemo(firstName: "Bob", lastName: "Jones", age: 27)
let charlie = PersonDemo(firstName: "Charlie", lastName: "Smith", age: 33)
let quentin = PersonDemo(firstName: "Quentin", lastName: "Alberts", age: 31)
let people:NSArray = ([alice, bob, charlie, quentin] as NSArray)

class ParentObject: NSObject {
    @objc dynamic public let objectBob = PersonDemo(firstName: "Bob", lastName: "Jones", age: 40)
}

class PredicateDemo:NSObject {
    
    
    let phoneNumbner1 = "13810234598";
    let phoneNumbner2 = "1381023459";
    
    
    let numbersArray = [1,2,3,6,79, -23];
    let namesArray = ["jack", "jacky", "winson", "will", "uweiyuan", "UweiX"]
    
    func testPredicate() -> Void {
        
        // MARK: - Regx
        let phoneRegx = "^[1][3-9]\\d{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegx)
        if phonePredicate.evaluate(with: phoneNumbner1) {
            print(phoneNumbner1);
        }
        
        if phonePredicate.evaluate(with: phoneNumbner2) {
            print(phoneNumbner2);
        }
        
        //MARK:- compare
        //  =, ==, >=, =>, <=, =<, >, <, !=, <>
        let numPredicate1 = NSPredicate(format: "SELF < 10", argumentArray:nil);
        let r1 = (numbersArray as NSArray).filtered(using: numPredicate1)
        print(r1)
        
//        let lE1 = NSExpression(forConstantValue: numbersArray)
//        let rE1 = NSExpression(forConstantValue: 10)
//        let cP1 = NSComparisonPredicate(leftExpression: lE1, rightExpression: rE1, modifier: .direct, type: .lessThan, options: .normalized)
//        print((numbersArray as NSArray).filtered(using: cP1))
        
        
        
        let numPredicate2 = NSPredicate(format: "SELF BETWEEN {0, 10}", argumentArray:nil);
        print((numbersArray as NSArray).filtered(using: numPredicate2))
        
        let boolValue = false
        let boolPredicate = NSPredicate(format: "self == TRUE")
        print("bool predicate result is \(boolPredicate.evaluate(with: boolValue))")
        
        
        //MARK:- Logic
        // AND, &&, OR, ||, NOT, !
        let p3 = NSPredicate(format: "SELF > 2 && SELF < 7", argumentArray: nil)
        for n in numbersArray {
           print("n is \(n) result is \(p3.evaluate(with: n))")
        }
        
        //MARK:- Strings
        // BEGINSWITH; CONTAINS; ENDSWITH; LIKE; MATCHES; UTI-CONFORMS-TO; UTI-EQUALS
        let p4 = NSPredicate(format: "SELF LIKE[cd] '?wei*'", argumentArray: nil)
        print((namesArray as NSArray).filtered(using: p4))

        let p5 = NSPredicate(format: "SELF MATCHES[cd] 'WINSON'", argumentArray: nil)
        print((namesArray as NSArray).filtered(using: p5))
        
        //MARK:- Set
        // ANY, SOME; ALL; NONE; IN;
        let p6 = NSPredicate(format: "age in {30,31, 32,33}", argumentArray: nil)
        print((people).filtered(using: p6))
        
        
        //MARK:- Object set
        let p7 = NSPredicate(format: "age >= 31", argumentArray: nil)
        print((people).filtered(using: p7))
        
        // 与上面等价
        let lE7 = NSExpression(forKeyPath: "age")
        let rE7 = NSExpression(forConstantValue: 31)
        let cp7 = NSComparisonPredicate(leftExpression: lE7, rightExpression: rE7, modifier: .direct, type: .greaterThanOrEqualTo, options: .normalized)
        print((people).filtered(using: cp7))
        
        
        let p8 = NSPredicate(format: "age >= 31 && age <= 33", argumentArray: nil)
        print((people).filtered(using: p8))
        
        let lE71 = NSExpression(forKeyPath: "age")
        let rE71 = NSExpression(forConstantValue: 33)
        let cp71 = NSComparisonPredicate(leftExpression: lE71, rightExpression: rE71, modifier: .direct, type: .lessThanOrEqualTo, options: .normalized)
        let cp8 = NSCompoundPredicate(andPredicateWithSubpredicates: [cp7, cp71])
        print((people).filtered(using: cp8))
        
        
        let p9 = NSPredicate(format: "firstName like[cd] 'Bo*'", argumentArray: nil)
        print((people).filtered(using: p9))
        
        let property = "lastName"
        let propertyValue = "smith"
        let p10 = NSPredicate(format: "%K contains[cd] %@", argumentArray: [property, propertyValue])
        print((people).filtered(using: p10))
        
        let ageProperty = "age"
        let agePropertyValue = 30
        let tempP11 = NSPredicate(format: "%K < $value", argumentArray: [ageProperty])
        let p11 = tempP11.withSubstitutionVariables(["value":agePropertyValue])
        print((people).filtered(using: p11))
        
        let p12 = tempP11.withSubstitutionVariables(["value":33])
        print((people).filtered(using: p12))
        
        // MARK:- key-path
        // Note: swfit中使用keypath，属性必须要使用dynamic来声明
        let p13 = NSPredicate(format: "objectBob.age > 30", argumentArray: nil)
        let pBob = ParentObject()
        print(pBob.objectBob.age)
        print("bob's age\(p13.evaluate(with: pBob) ? " >" : "<") 30")
        
        
        //MARK:- Expression function
        let sumExpression = NSExpression(forFunction: "stddev:", arguments: [NSExpression(forConstantValue: numbersArray)])
        let result = sumExpression.expressionValue(with: nil, context: nil)
        print(result ?? "result is nil")
    }
    
}
