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
        AppAppearance.setupSearchBarAppearance(searchBar: UISearchBar.appearance())
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
        buttonAppearance.normal.titleTextAttributes = [.strokeColor: ColorStyle.bkgrndWhite.color,
                                                       .foregroundColor: ColorStyle.bkgrndWhite.color,
                                                       .font: UIFont.systemFont(ofSize: 16)]
        appearance.buttonAppearance = buttonAppearance
        navBar.standardAppearance = appearance
    }

    static func setupSearchBarAppearance(searchBar: UISearchBar) {
        //TODO: fix searh icon size & cancel button height
        searchBar.setImage(#imageLiteral(resourceName: "SearchBar"), for: .search, state: UIControl.State())
        searchBar.setSearchFieldBackgroundImage(#imageLiteral(resourceName: "SearchBackground"), for: UIControl.State())
        searchBar.tintColor = ColorStyle.orange.color
        searchBar.barStyle = .default
        searchBar.searchBarStyle = .minimal
        searchBar.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: .search)
//        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: Units.u2.rawValue, vertical: 0)

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .defaultTextAttributes = [NSAttributedString.Key.foregroundColor: ColorStyle.darkGray.color,
                                      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]

//        let barButton = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
//        barButton.style = .done
//        barButton.setTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: 2), for: .default)
//        barButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ColorStyle.orange.color,
//                                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)],
//                                         for: UIControl.State())
    }
}
