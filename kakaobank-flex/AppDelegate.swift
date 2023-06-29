//
//  AppDelegate.swift
//  kakaobank-flex
//
//  Created by 김수아 on 2023/06/29.
//

import UIKit
import RIBs

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let router = BiasRootBuilder(dependency: StubComponent()).build(withListener: self)
        self.router = router
        
        router.load()
        router.interactable.activate()
        
        let window = UIWindow()
        window.rootViewController = UINavigationController(rootViewController: router.viewControllable.uiviewController)
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    internal var window: UIWindow?
    private var router: ViewableRouting?
}

extension AppDelegate: BiasRootListener{
    
}

private class StubComponent: Component<EmptyDependency>, BiasRootDependency{
    init() {
        super.init(dependency: EmptyComponent())
    }
}
