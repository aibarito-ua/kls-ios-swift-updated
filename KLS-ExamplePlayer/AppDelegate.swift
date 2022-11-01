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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var kollusStorage : KollusStorage?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if kollusStorage == nil {
            kollusStorage = KollusStorage()
            kollusStorage?.applicationKey = ""
            kollusStorage?.applicationBundleID = ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            kollusStorage?.applicationExpireDate = dateFormatter.date(from: "")
            kollusStorage?.serverPort = 0
            
            do {
                try kollusStorage?.start()
            } catch {
                print("Storage Start Err: ", error.localizedDescription)
            }
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // 오디오 세션 카테고리, 모드, 옵션을 설정합니다.
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category.")
        }
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

