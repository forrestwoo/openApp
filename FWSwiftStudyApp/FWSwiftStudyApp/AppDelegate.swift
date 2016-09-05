//
//  AppDelegate.swift
//  FWSwiftStudyApp
//
//  Created by Forrest Woo on 16/4/3.
//  Copyright © 2016年 ForrstWoo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //        let vegetable = "red pepper"
        //        switch vegetable {
        //        case "celery":
        //            print("Add some raisins and make ants on a log.")
        //        case "cucumber", "watercress":
        //            print("That would make a good tea sandwich.")
        //        case let x where x.hasSuffix("pepper"):
        //            print("Is it a spicy \(x)?")
        //        default:
        //            print("Everything tastes good in soup.")
        //        }
        //        let http404error = (404,"NOT FOUND!")
        //        let (statusCode, _) = http404error
        //        let httpError = (statusCode:404,statusMessage:"Not Found!")
        //        print("The status code is \(statusCode)")
        
        //        let unusualMenagerie = "Koala 🐨, Snail 🐌, Penguin 🐧, Dromedary 🐪"
        //        print("unusualMenagerie has \(unusualMenagerie.characters.count) characters")
        //
        //        var word = "cafe"
        //        print("the number of characters in \(word) is \(word.characters.count)")
        //        // Prints "the number of characters in cafe is 4"
        //
        //        word += "\u{301}"    // COMBINING ACUTE ACCENT, U+0301
        //
        //        print("the number of characters in \(word) is \(word.characters.count)")
        //        // Prints "the number of characters in café is 4”
        //        print(greeting[greeting.startIndex])
        //        // G
        //
        //        //        print(greeting[greeting.endIndex])
        //        print(greeting[greeting.endIndex.predecessor()])
        ////        print(greeting[greeting.startIndex.predecessor()])
        //        // !
        //        print(greeting[greeting.startIndex.successor()])
        ////        print(greeting[greeting.endIndex.successor()])
        //        // u
        //        let index = greeting.startIndex.advancedBy(7)
        //        print(greeting[index])
        //        let greeting = "Guten Tag!"
        //        for index in greeting.characters.indices {
        //            print("\(greeting[index]) ", terminator: "")
        //        }
        //        var someInts = [Int]()
        //        print("someInts is of type [Int] with \(someInts.count) items.")
        //
        //        var favoriteGenres: Set = ["Rock", "Classical", "Hip hop"]
        //
        
        //        var arr = [1,2,3,4];
        //
        //        let sum = arr.reduce(0, combine: +)
        
//        let arr = ["ForrestWoo","Swift1"]
//        let str = "My name is ForrestWoo,I am learning Swift"
//        let query = arr.contains(str.containsString)
//        print(query)
        let name = "Forrest"
        (1...4).forEach{print("Happy Birthday " + (($0 == 3) ? "dear \(name)":"to You"))}

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
    
    
}

