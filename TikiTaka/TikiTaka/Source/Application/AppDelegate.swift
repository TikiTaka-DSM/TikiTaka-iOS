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
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

        if TokenManager.currentToken?.tokens.accessToken != nil {
            let viewController = storyboard.instantiateViewController(withIdentifier: "Main")

            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }else {
            let viewController = storyboard.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController

            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SocketIOManager.shared.socket.disconnect()
    }
    
}

