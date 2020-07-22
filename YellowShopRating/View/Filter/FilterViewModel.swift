//
//  SearchViewModel.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 18/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import CoreLocation
import GoogleSignIn

class FilterViewModel: ObservableObject {
    
    @Binding var filterSetting : AppSetting
    @Binding var closeFlag : Bool
    @Published var showSignIn : Bool = false
    @Published var signInFlag : Int = 0
    @Published var pageSetting = AppSetting()
    var categoryList : [String]
        
    init(filterSetting:Binding<AppSetting> ,closeFlag : Binding<Bool>,categoryList : [String]) {
        self._filterSetting = filterSetting
        self.pageSetting = filterSetting.wrappedValue
        self.categoryList = categoryList
        self._closeFlag = closeFlag
        self.signInFlag = UserDefaults.standard.integer(forKey: UserDefaultsKey.LoginFlag) ?? 0
    }
    
    func search(){
        self.filterSetting = pageSetting
        self.closeFlag = false
    }
    
    
    
    func logout(){
        try! Auth.auth().signOut()
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.LoginFlag)
        NotificationCenter.default.post(name: .dismissMainView ,object: nil)
        print("Completed logout")
    }
    
}
