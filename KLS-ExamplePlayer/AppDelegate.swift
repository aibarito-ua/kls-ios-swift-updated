//
//  AppDelegate.swift
//  kls-ios-swift
//
//  Created by 양현덕 on 2020/05/14.
//  Copyright © 2020 양현덕. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var kollusStorage : KollusStorage?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if kollusStorage == nil {
            kollusStorage = KollusStorage()
            kollusStorage?.applicationKey = "0e8de8edb342d5fd5bf2f4a1ecaec5417e96f869"
            kollusStorage?.applicationBundleID = Bundle.main.bundleIdentifier
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            kollusStorage?.applicationExpireDate = dateFormatter.date(from: "2025/01/31")
            kollusStorage?.serverPort = 7594
            
            
            do {
                try kollusStorage?.start()
            } catch {
                print("Storage Start Err: ", error.localizedDescription)
            }
        }
        
        application.beginReceivingRemoteControlEvents()
        return true
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

