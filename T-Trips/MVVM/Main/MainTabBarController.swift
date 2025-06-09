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
        tripsVC.title = "trips".localized
        let tripsNav = UINavigationController(rootViewController: tripsVC)
        tripsNav.tabBarItem = UITabBarItem(
            title: "trips".localized,
            image: UIImage(systemName: "mappin"),
            tag: 0
        )

        let notifVC = NotificationsViewController()
        notifVC.title = "notifications".localized
        let notifNav = UINavigationController(rootViewController: notifVC)
        notifNav.tabBarItem = UITabBarItem(
            title: "notifications".localized,
            image: UIImage(systemName: "bell"),
            tag: 1
        )

        let settingsVC = SettingsViewController()
        settingsVC.title = "settings".localized
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(
            title: "settings".localized,
            image: UIImage(systemName: "gearshape"),
            tag: 2
        )

        viewControllers = [tripsNav, notifNav, settingsNav]
        tabBar.tintColor = .systemBlue
    }
}
