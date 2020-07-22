//
//  SceneDelegate.swift
//  YellowShopRating
//
//  Created by Kwok Wai Yeung on 12/6/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
//            let contentView = FrontEndController()
            window.rootViewController = UIHostingController(rootView: MainView())
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

