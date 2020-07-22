//
//  AppDelegate.swift
//  YellowShopRating
//
//  Created by Kwok Wai Yeung on 12/6/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,GIDSignInDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate  = self
        GMSServices.provideAPIKey("AIzaSyCsxDhr6tzn1PevbYTlhOqBRl9RhkQxX_8")
        return true
    }
   
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }else{
            guard let authentication = user.authentication else { return }
            print("Signed In by Google")
            var tempUser = ProviderUser()
            tempUser.userName = user.profile.name
            tempUser.firstName = user.profile.givenName
            tempUser.lastName = user.profile.familyName
            tempUser.email = user.profile.email
            tempUser.imgUrl = user.profile.imageURL(withDimension: 100)?.absoluteString
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
            let tokenDict:[String: Any] = ["token": credential , "user": tempUser ]
            NotificationCenter.default.post(name: .loginCompleted, object: nil,userInfo: tokenDict)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let urlScheme = url.scheme else { return false }
        print("Schema : \(urlScheme)")
        var facebookOrGoogle : Bool = false
        facebookOrGoogle = (GIDSignIn.sharedInstance()?.handle(url))!
        return facebookOrGoogle
    
    }
    

}


extension UIApplication {
    var window: UIWindow? {
        connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
    }
    
    func endEditing() {
           sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
       }
}

