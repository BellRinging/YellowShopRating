//
//  RegisterPage.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 2/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct RegisterPage: View {
    
   @ObservedObject var viewModel: RegisterViewModel
    
    init(closeFlag : Binding<Bool> ){
        viewModel = RegisterViewModel(closeFlag: closeFlag )
    }
    
    var body: some View {
        NavigationView{
            VStack{
               
                Text("")
                Form {
                    Section(header: Text("Email").textStyle(size: 16))
                    {
                        TextField("Email Address", text: self.$viewModel.email)
                                                     .autocapitalization(.none)
                    }
                    Section(header:
                        Text("Password")
                            .font(MainFont.forSmallTitleText())){
                                SecureField("Password", text: self.$viewModel.password)
                                    .autocapitalization(.none)
                                SecureField("Re-enter the password", text: self.$viewModel.reEnterPassword)
                                    .autocapitalization(.none)
                    }
                }
                Spacer()
            }
            .navigationBarTitle("Register")
            .navigationBarItems(leading:  CancelButton(self.viewModel.$closeFlag), trailing: ConfirmButton(){
                self.viewModel.handleRegister()
            })
        }
    }

}
