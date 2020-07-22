import Foundation
import SwiftUI
import Promises
import Firebase
import FirebaseAuth

class RegisterViewModel: ObservableObject {
  
    @Published var email : String = ""
    @Published var password : String = ""

    @Published var reEnterPassword : String = ""
    @Binding var closeFlag : Bool

    init(closeFlag: Binding<Bool> ){
        self._closeFlag = closeFlag
    }
    
    func handleRegister(){
        if self.validField() {
            createUserInDb().then { _ in
                Utility.showAlert(message: "Account created")
            }.catch { (err) in
                Utility.showAlert(message: err.localizedDescription)
            }
        }
    }
    
    
    func validField() -> Bool{
        
        if self.email == "" {
            Utility.showAlert(message: "Email is required.Please enter your email")
            return false
        }
        
       
        if self.password == "" {
            Utility.showAlert(message: "Password is required.Please enter your number")
            return false
        }
        if self.reEnterPassword == "" {
            Utility.showAlert( message: "Password is required.Please enter your number")
            return false
        }
        
        if self.reEnterPassword != password {
            Utility.showAlert( message: "Password is required.Please enter your number")
            return false
        }
    
        return true
    }

   
    func createUserInDb() -> Promise<FirebaseAuth.User>  {
        let p = Promise<FirebaseAuth.User> { (resolve , reject) in
            Auth.auth().createUser(withEmail: self.email, password: self.password) { (result, err) in
                guard let user = result?.user else {
                    reject(err!)
                    return
                }
                print("createUserInDb success return")
                resolve(user)
            }
        }
        return p
    }
}
