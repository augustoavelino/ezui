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
    
    // MARK: Properties
    
    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    // MARK: - Life cycle
    
    func application(
        _ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let _window = UIWindow(frame: UIScreen.main.bounds)
        window = _window
        startCoordinator(in: _window)
        loadTintColor()
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        AppCacheManager.shared.clearCaches()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        AppCoreDataManager.shared.saveIfChanged()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        AppCoreDataManager.shared.saveIfChanged()
    }
    
    // MARK: - Helpers
    
    private func startCoordinator(in window: UIWindow) {
        coordinator = AppCoordinator(window: window)
        coordinator?.start()
    }
    
    private func loadTintColor() {
        do {
            let tintColor = try SettingsTintManager.shared.getTintColor().get()
            window?.tintColor = tintColor
        } catch {
            print("ERROR LOADING TINT FROM DEFAULTS: \(error)")
        }
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let menuCoordinator = coordinator?.children.first as? SourceMenuCoordinatorProtocol else { return completionHandler(false) }
        menuCoordinator.performRoute(.root, animated: false)
        if shortcutItem.type == "ColorPalettes" {
            menuCoordinator.performRoute(.styles(.colorPalette), animated: false)
        } else if shortcutItem.type == "Strings" {
            menuCoordinator.performRoute(.resources(.strings), animated: false)
        }
        completionHandler(true)
    }
}
