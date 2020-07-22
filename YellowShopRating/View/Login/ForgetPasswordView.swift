//
//  Terms.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 29/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ForgetPasswordView: View {
    
    @Binding var closeFlag : Bool
    @State var email : String = ""
    
    var body: some View {
        NavigationView{
            
            VStack{
                
                TextField("Email:", text: $email)
                              .textStyle(size: 16)
                              .padding()
                              .cornerRadius(10)
                              .background(Color.whiteGaryColor)
                          .autocapitalization(.none)
//
                Button(action: {
                    self.forgetPassword()
                }){
                    HStack(alignment: .center) {
                        Text("Submit")
                            .textStyle(size: 16 , color: Color.white)
                            .frame(maxWidth:.infinity)
                    }.padding()
                }
                .background(Color.greenColor)
                .padding()
                .shadow(radius: 5)
                Spacer()
                }
            .navigationBarTitle("Forget Password", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$closeFlag))
        }
    }
    
    func forgetPassword(){
        if self.email == "" {
            Utility.showAlert(message:"Please type in the email")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: self.email) { error in
            if let err = error {
                Utility.showAlert(message: err.localizedDescription)
            }else{
                  Utility.showAlert(message:"Email Sent")
            }
        }
    }
}



//struct Terms_Previews: PreviewProvider {
//    static var previews: some View {
//        Terms()
//    }
//}
