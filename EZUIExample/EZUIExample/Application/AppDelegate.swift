//
//  AppDelegate.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 01/02/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = makeRootViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    private func makeRootViewController() -> UIViewController {
        let viewController = TypographyViewController(viewModel: TypographyViewModel())
        return UINavigationController(rootViewController: viewController)
    }
}
