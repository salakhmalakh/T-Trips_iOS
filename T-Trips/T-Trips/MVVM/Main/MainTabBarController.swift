//
//  MainTabBarController.swift
//  T-Trips
//
//  Created by Тимур Салахиев on 24.05.2025.
//

import Foundation
import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    // MARK: - filling up the TabBar
    private func setupViewControllers() {
        let tripsVC = TripsViewController()
        tripsVC.title = "Поездки"
        let tripsNav = UINavigationController(rootViewController: tripsVC)
        tripsNav.tabBarItem = UITabBarItem(
            title: "Поездки",
            image: UIImage(systemName: "mappin"),
            tag: 0
        )
        
        //        let notifVC = NotificationsViewController()
        //        notifVC.title = "Уведомления"
        //        let notifNav = UINavigationController(rootViewController: notifVC)
        //        notifNav.tabBarItem = UITabBarItem(
        //            title: "Уведомления",
        //            image: UIImage(systemName: "bell"),
        //            tag: 1
        //        )
        //
        //        let settingsVC = SettingsViewController()
        //        settingsVC.title = "Настройки"
        //        let settingsNav = UINavigationController(rootViewController: settingsVC)
        //        settingsNav.tabBarItem = UITabBarItem(
        //            title: "Настройки",
        //            image: UIImage(systemName: "gearshape"),
        //            tag: 2
        //        )
        // TODO: create new screens and add them into the braces below
        viewControllers = [tripsNav]
        tabBar.tintColor = .systemBlue
    }
}
