import SwiftUI
import GoogleSignIn
import Firebase
import FirebaseAuth
import Promises
import AuthenticationServices

struct SocialLogin: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<SocialLogin>) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SocialLogin>) {
        
    }

    func attemptLoginGoogle() {
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
    }

    
    func firebaseLogin(_ credentials: AuthCredential , provider:String , user : ProviderUser) {
        Utility.showProgress()
        loginToFirebase(credentials).then { tempUser in
                NotificationCenter.default.post(name: .dismissSwiftUI, object: nil)
        }.catch{ err in
            print("Fail to create login into firebase")
            Utility.showAlert(message: err.localizedDescription)
        }.always {
            Utility.hideProgress()
        }
    }
    

    
    func loginToFirebase(_ credentials: AuthCredential) -> Promise<FirebaseAuth.User> {
        
         let p = Promise<FirebaseAuth.User> { (resolve , reject) in
            Auth.auth().signIn(with: credentials, completion: { (result, err) in
                guard let user = result?.user else {
                    reject(err!)
                    return
                }
                UserDefaults.standard.set(1, forKey: UserDefaultsKey.LoginFlag)
                resolve(user)
            })
        }
        return p
    }

}
