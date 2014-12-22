//
//  AppDelegate.swift
//  Jumble
//
//  Created by Aaron Taylor on 11/8/14.
//  Copyright (c) 2014 Hamsterdam. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)

    let thingsViewController = ThingsViewController(nibName: nil, bundle: nil)

    window?.rootViewController = thingsViewController

    window?.makeKeyAndVisible()

    return true
  }
}

