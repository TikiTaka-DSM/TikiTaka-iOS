//
//  AppDelegate.swift
//  TikiTaka
//
//  Created by 이가영 on 2020/12/14.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SocketIOManager.shared.socket.disconnect()
    }
}

