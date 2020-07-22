//
//  UIColor+Utils.swift
//  SwiftEntryKit
//
//  Created by Daniel Huri on 4/20/18.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import UIKit
import SwiftEntryKit
import SwiftUI

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func yellow0() -> UIColor {
       return UIColor(red: 255/255, green: 254/255, blue: 200/255, alpha: 1)
     }
     static func yellow1() -> UIColor {
       return UIColor(red: 255/255, green: 253/255, blue: 184/255, alpha: 1)
     }
     
     static func yellow2() -> UIColor {
       return UIColor(red: 253/255, green: 246/255, blue: 140/255, alpha: 1)
     }
     
     static func yellow3() -> UIColor {
       return UIColor(red: 244/255, green: 205/255, blue: 42/255, alpha: 1)
     }

     static func yellow4() -> UIColor {
       return UIColor(red: 254/255, green: 209/255, blue: 54/255, alpha: 1)
     }
     static func yellow5() ->  UIColor {
       return UIColor(red: 191/255, green: 155/255, blue: 48/255, alpha: 1)
     }
    

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
    
  
extension SwiftUI.Color {
    static var grayColor: SwiftUI.Color {
        return SwiftUI.Color.init(red: 90/255, green: 90/255, blue: 90/255)
      }
    
    static var greenColor : SwiftUI.Color {
        return self.init(red: 6/255, green: 126/255, blue: 65/255)
    }
    
    static var redColor : SwiftUI.Color {
        return self.init(red: 225/255, green: 0/255, blue: 0/255)
    }
    
    static var textColor: SwiftUI.Color {
          return SwiftUI.Color.init(red: 29/255, green: 29/255, blue: 29/255)
        }
    static var navBarColor: SwiftUI.Color {
          return SwiftUI.Color.init(red: 225/255, green: 0/255, blue: 0/255)
        }
    
    static var whiteGaryColor: SwiftUI.Color {
      return SwiftUI.Color.init(red: 242/255, green: 243/255, blue: 244/255)
    }

 
    
}
