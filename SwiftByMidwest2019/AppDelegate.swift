//
//  AppDelegate.swift
//  SwiftByMidwest2019
//
//  Created by Jacob Van Order on 3/15/19.
//  Copyright © 2019 Jacob Van Order. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard
            let talkRouterSplitViewController = window?.rootViewController as? TalkRouterSplitViewController,
            let navigationController = talkRouterSplitViewController.viewControllers.first as? UINavigationController,
            let talkListTableViewController = navigationController.viewControllers.first as? TalkListTableViewController,
            let talkDetailViewController = talkRouterSplitViewController.viewControllers.last as? TalkDetailViewController else {
                fatalError("Configuration of the project is NOT what you expect…:\n")
        }
        
        talkListTableViewController.talkRouterDelegate = talkRouterSplitViewController
        talkDetailViewController.navigationItem.leftBarButtonItem = talkRouterSplitViewController.displayModeButtonItem
        talkDetailViewController.navigationItem.leftItemsSupplementBackButton = true
        
        talkRouterSplitViewController.delegate = self
        talkRouterSplitViewController.preferredDisplayMode = .allVisible
        
        return true
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if
            let talkRouterSplitViewController = window?.rootViewController as? TalkRouterSplitViewController {
            talkRouterSplitViewController.restoreUserActivityState(userActivity)
            return true
        }
        return false
    }
}

extension AppDelegate: UISplitViewControllerDelegate {    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let _ = secondaryViewController as? TalkDetailViewController else { return true }
        return true
    }
}

