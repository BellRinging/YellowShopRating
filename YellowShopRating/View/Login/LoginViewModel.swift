import Promises
import SwiftUI
import Firebase
import FirebaseAuth
import Combine
import AuthenticationServices

class LoginViewModel: ObservableObject {

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showRegisterPage: Bool = false
    @Published var showForgetPassword: Bool = false
    @Binding var loginFlag : Int
    @Binding var closeFlag : Bool

    private var tickets: [AnyCancellable] = []
    
    init(closeFlag:Binding<Bool>, loginFlag:Binding<Int>){
        self._closeFlag = closeFlag
        self._loginFlag = loginFlag
        addNotification()
    }
    
    func addNotification(){
         NotificationCenter.default.publisher(for: .loginCompleted)
             .compactMap{$0.userInfo as NSDictionary?}
             .sink {(dict) in
                 if let credential = dict["token"] as? AuthCredential , let tempUser = dict["user"] as? ProviderUser {
                     SocialLogin().firebaseLogin(credential, provider: "google",user:tempUser)
                 }
         }.store(in: &tickets)
     }
    
    func normalLogin(){
        print("SignIn by Email")
        if self.validField() {
            Utility.showProgress()
            normalLoginByUser(email: email, password: password).then { user in
                 NotificationCenter.default.post(name: .dismissSwiftUI, object: nil)
            }.catch { (err) in
                Utility.showAlert(message: err.localizedDescription)
            }.always {
                Utility.hideProgress()
            }
        }
    }
    
    func validField() -> Bool{
        if email == "" {
            Utility.showAlert( message: "Email is required.Please enter your email")
            return false
        }
        
        if password == "" {
            Utility.showAlert(message: "Password is required.Please enter your number")
            return false
        }
        return true
    }
    
    func normalLoginByUser(email:String,password:String) ->Promise<FirebaseAuth.User>{
         let p = Promise<FirebaseAuth.User> { (resolve , reject) in
             Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                 if let err = error {
                     reject(err)
                    return
                 }
                 print("login by email success ,show main page")
                UserDefaults.standard.set(1, forKey: UserDefaultsKey.LoginFlag)
                self.loginFlag = 1
                self.closeFlag.toggle()
                resolve(result!.user)
             }
         }
         return p
     }
}

