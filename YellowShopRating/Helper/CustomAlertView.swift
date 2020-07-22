//
//  CustomAlertView.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 30/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import SwiftEntryKit
import UIKit

struct CustomAlertView: View {
    
    var message : String
    typealias Action = () -> ()
    var callBack: Action?
    
    var body: some View {
        VStack{
            Text(message).textStyle(size: 12).padding()
            HStack{
                if callBack != nil {
                    Button("Cancel"){
                        SwiftEntryKit.dismiss()
                    }
                    .frame(width:100 ,height : 30)
                        //                .background(Color.red)
                        .foregroundColor(Color.red)
                        .cornerRadius(10)
                        .padding()
                    
                    
                    Button("Confirm"){
                        print("confirm")
                        if let callBack = self.callBack{
                            callBack()
                        }
                        SwiftEntryKit.dismiss()
                    }
                    .frame(width:100,height : 30)
                        //                .background(Color.green)
                        .foregroundColor(Color.green)
                        .cornerRadius(10)
                    
                }else{
                    Button("Dismiss"){
                        SwiftEntryKit.dismiss()
                    }
                }
            }.padding()
        }
    }
}
