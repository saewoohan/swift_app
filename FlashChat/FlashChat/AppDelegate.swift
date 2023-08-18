//
//  AppDelegate.swift
//  FlashChat
//
//  Created by 한승우 on 2022/12/28.
//

import UIKit
import FirebaseCore
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
                   [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

