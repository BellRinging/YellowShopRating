//
//  Font.swift
//  SwiftEntryKit_Example
//
//  Created by Daniel Huri on 4/23/18.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import UIKit
import SwiftUI

typealias MainFont = Font2.HelveticaNeue
typealias ChineseFont = Font2.PingFangHK




enum Font2 {
    enum HelveticaNeue: String {
        case ultraLightItalic = "UltraLightItalic"
        case medium = "Medium"
        case mediumItalic = "MediumItalic"
        case ultraLight = "UltraLight"
        case italic = "Italic"
        case light = "Light"
        case thinItalic = "ThinItalic"
        case lightItalic = "LightItalic"
        case bold = "Bold"
        case thin = "Thin"
        case condensedBlack = "CondensedBlack"
        case condensedBold = "CondensedBold"
        case boldItalic = "BoldItalic"
        
        func with(size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-\(rawValue)", size: size)!
        }
        
        func size(_ size: CGFloat) -> SwiftUI.Font {
            return SwiftUI.Font.custom("HelveticaNeue-\(rawValue)", size: size)
        }
        
        static func forPlaceHolder() -> SwiftUI.Font {
            return SwiftUI.Font.custom("HelveticaNeue-Light", size: 16)
        }
        
        static func forButtonText() -> SwiftUI.Font {
            return SwiftUI.Font.custom("HelveticaNeue-Bold", size: 16)
        }
        
        static func forTitleText() -> SwiftUI.Font {
            return SwiftUI.Font.custom("HelveticaNeue-Medium", size: 32)
        }
        
        static func forSmallTitleText() -> SwiftUI.Font {
            return SwiftUI.Font.custom("HelveticaNeue-Bold", size: 24)
        }
    }
    
    enum PingFangHK: String {
        case ultraLight = "Ultralight"
        case medium = "Medium"
        case light = "Light"
        case thin = "Thin"
        case regular = "Regular"
        case semiBold = "Semibold"
            
        func with(size: CGFloat) -> UIFont {
            return UIFont(name: "PingFangHK-\(rawValue)", size: size)!
        }
        
        func size(_ size: CGFloat) -> SwiftUI.Font {
            return SwiftUI.Font.custom("PingFangHK-\(rawValue)", size: size)
        }
    }
}

extension Font {
    public static func FHACondFrenchNC(size: CGFloat) -> Font {
        return Font.custom("FHA Condensed French NC", size: size)
    }
    
    public static func AmericanCaptain(size: CGFloat) -> Font {
        return Font.custom("American Captain", size: size)
    }
    
    public static func FjallaOne(size: CGFloat) -> Font {
        return Font.custom("FjallaOne-Regular", size: size)
    }
}



extension View {
    func titleFont(size: CGFloat, color : Color = Color.textColor) -> some View {
        return ModifiedContent(content: self, modifier: TitleFont(size: size,color : color))
    }
    
    func titleStyle(color : Color = Color.textColor) -> some View {
        return ModifiedContent(content: self, modifier: TitleFont(size: 16,color : color))
    }

     func normalTextStyle(color : Color = Color.textColor) -> some View {
            return ModifiedContent(content: self, modifier: TextFont(size: 16,color : color))
        }
    
    func textStyle(size: CGFloat , color : Color = Color.textColor) -> some View {
        return ModifiedContent(content: self, modifier: TextFont(size: size ,color : color))
    }
     

    func normalTextSubStyle(color : Color = Color.textColor) -> some View {
           return ModifiedContent(content: self, modifier: TextFont(size: 14,color : color))
       }
    
}

struct TitleFont: ViewModifier {
    let size: CGFloat
    let color: Color
    
    func body(content: Content) -> some View {
        return content.font(.AmericanCaptain(size: size)).foregroundColor(color)
    }
}



struct TextFont: ViewModifier {
    let size: CGFloat
    let color: Color
    
    init(size:CGFloat,color:Color) {
        self.size = size
        self.color = color
    }
    
    func body(content: Content) -> some View {
        return content.font(.FjallaOne(size: size)).foregroundColor(color)
    }
}
