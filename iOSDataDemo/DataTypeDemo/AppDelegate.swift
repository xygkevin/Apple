//
//  AppDelegate.swift
//  DataTypeDemo
//
//  Created by uwei on 7/29/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        characterSetDemo()
        stringDemo()
        
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    func characterSetDemo() -> Void {
        let whiteSpaceAndNewLineSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        print(whiteSpaceAndNewLineSet)
        let invertedSet = whiteSpaceAndNewLineSet.invertedSet
        print(invertedSet)
        
        let result = invertedSet.isSupersetOfSet(whiteSpaceAndNewLineSet)
        print(result)
        let u:unichar = ("\n" as NSString).characterAtIndex(0)
        let isMember = whiteSpaceAndNewLineSet.characterIsMember(u)
        print(isMember)
    }
    
    
    func stringDemo() -> Void {
        let string1 = "uwei" as NSString
        let s1 = string1.cStringUsingEncoding(NSUTF8StringEncoding)
        print(s1)
        let s2 = string1.stringByAppendingString("yuan")
        print(s1)
        print(string1)
        print(s2)
        
        let s3 = "first\nsecond\nthird\n" as NSString
        s3.enumerateLinesUsingBlock { (line, stop) in
            print(line)
        }
        
        
        let textToAnalyse = "袁有为 Alice and Bob go out for a walk. In the forest, they meet the little brown squirrel Felix." as NSString
//        let textToAnalyse = "袁有为要去吃饭" as NSString
        
        // This range contains the entire string, since we want to parse it completely
        let stringRange = NSMakeRange(0, textToAnalyse.length);
        
        // Dictionary with a language map
//        let language = NSArray.init(array: ["zh"])
        let language = NSArray.init(array: ["en","de","fr"])
        let languageMap:[String:[String]] = NSDictionary.init(object: language, forKey: "Latn") as! [String : [String]]
        textToAnalyse.enumerateLinguisticTagsInRange(stringRange, scheme: NSLinguisticTagSchemeLexicalClass, options:[.OmitPunctuation, .OmitWhitespace], orthography: NSOrthography.init(dominantScript: "Latn", languageMap: languageMap)) { (tag, tokenRange, sentenceRange, stop) in
            print("\(textToAnalyse.substringWithRange(tokenRange)) is a \(tag), tokenRange (\(tokenRange.length),\(tokenRange.location)), sentenceRange (\(sentenceRange.length),\(sentenceRange.location))")
        }
        
        
        let enString = "bottle" as NSMutableString
//        let x:NSRange
        enString.applyTransform(NSStringTransformLatinToKatakana, reverse: false, range:NSMakeRange(0, enString.length), updatedRange: nil)
        print(enString)
        
    }
    


}

