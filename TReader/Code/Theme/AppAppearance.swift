//
//  AppAppearance.swift
//  TReader
//
//  Created by tadas on 2020-02-14.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

struct AppAppearance {
    func setup() {
        AppAppearance.setupTabbarAppearance(UITabBar.appearance())
        AppAppearance.setupNavBarAppearance(UINavigationBar.appearance())
    }

    static func setupTabbarAppearance(_ tabBar: UITabBar) {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = ColorStyle.menuGray.color
        tabBar.standardAppearance = appearance
    }

    static func setupNavBarAppearance(_ navBar: UINavigationBar) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = ColorStyle.textGray.color
        navBar.standardAppearance = appearance
    }
    
}
