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
        appearance.stackedLayoutAppearance.normal.iconColor = ColorStyle.iconsLight.color
        appearance.stackedLayoutAppearance.selected.iconColor = ColorStyle.menuDark.color
        tabBar.standardAppearance = appearance
    }

    static func setupNavBarAppearance(_ navBar: UINavigationBar) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = ColorStyle.textGray.color
        appearance.titleTextAttributes = [.foregroundColor: ColorStyle.bkgrndWhite.color]
        appearance.largeTitleTextAttributes = [.foregroundColor: ColorStyle.bkgrndWhite.color]
        appearance.setBackIndicatorImage(#imageLiteral(resourceName: "Back"), transitionMaskImage: #imageLiteral(resourceName: "Back"))

        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: ColorStyle.bkgrndWhite.color,
                                                       .font: UIFont.systemFont(ofSize: 16)]
        appearance.buttonAppearance = buttonAppearance

        navBar.standardAppearance = appearance
    }
}
