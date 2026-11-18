//
//  TabBarController.swift
//  Sparkle
//
//  Created by Letícia Marreiro Lopes Silva on 17/11/26.
//
import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        customizeTabBarAppearance()
    }
    private func setupTabs() {
        let homePage = ViewController()
        let monthViewPage = MonthViewController()
        
        homePage.tabBarItem = UITabBarItem(title: "Início", image: UIImage(systemName: "house"), tag: 0)
        monthViewPage.tabBarItem = UITabBarItem(title: "Calendário", image: UIImage(systemName: "calendar"), tag: 1)
        
        let nav1 = UINavigationController(rootViewController: homePage)
        let nav2 = UINavigationController(rootViewController: monthViewPage)
        
        setViewControllers([nav1, nav2], animated: true)
    }
    
    private func customizeTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.configureWithTransparentBackground()
        tabBar.tintColor = .labelColor
    }
}
