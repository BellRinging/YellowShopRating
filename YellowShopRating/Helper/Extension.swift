//
//  Extendsion.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/7/2017.
//  Copyright © 2017 Kwok Wai Yeung. All rights reserved.
//

import UIKit
import SwiftUI

extension Notification.Name {
    static let selectPlace = Notification.Name("selectPlace")
    static let updateMarker = Notification.Name("updateMarker")
    static let updateLocation = Notification.Name("updateLocation")
    static let clearPlace = Notification.Name("clearPlace")
    static let locatePlace = Notification.Name("locatePlace")
    static let loginCompleted = Notification.Name("loginCompleted")
    static let dismissSwiftUI = Notification.Name("dismissSwiftUI")
    static let dismissMainView = Notification.Name("dismissMainView")

    
}


extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            if let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame {
                let statusBarView = UIView(frame: statusBarFrame)
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            } else if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            } else {
                return nil
            }
        }else{
            return nil
        }
    }
}


struct UserDefaultsKey  {
    static let CurrentUser = "CurrentUser"
    static let  CurrentGroup = "CurrentGroup"
    static let  CurrentGroupUser = "CurrentGroupUser"
    static let  LoginFlag = "LoginFlag"
    static let  FcmToken = "FcmToken"
    static let  AppleIdUser = "AppleIdUser"
    static let  ActAsUser = "ActAsUser"
    
}

extension UserDefaults {
   func save<T:Encodable>(customObject object: T, inKey key: String) {
       let encoder = JSONEncoder()
       if let encoded = try? encoder.encode(object) {
           self.set(encoded, forKey: key)
       }
   }

   func retrieve<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
       if let data = self.data(forKey: key) {
           let decoder = JSONDecoder()
           if let object = try? decoder.decode(type, from: data) {
               return object
           }else {
               print("Couldnt decode object for key : \(key)")
               return nil
           }
       }else {
           return nil
       }
   }
}


extension Int: Identifiable {
  public var id: Int {
    return self
  }
}

extension String: Identifiable {
  public var id: String {
    return self
  }
}

extension View {
    
    func standardImageStyle() -> some View {
        return ModifiedContent(content: self, modifier: StandardSize(width: 40, height: 40))
    }
    
    func ImageStyle(size : CGFloat) -> some View {
          return ModifiedContent(content: self, modifier: StandardSize(width: size, height: size))
      }
}

struct StandardSize: ViewModifier {
    let width: CGFloat
    let height: CGFloat
    
    func body(content: Content) -> some View {
        return content.frame(width: width, height: height)
    }
}
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
