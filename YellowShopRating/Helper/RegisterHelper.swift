import Promises
import Firebase
import FirebaseAuth
import FirebaseFirestore


struct RegisterHelper{
    
    static func registerUserIntoDatabase(_ user:ProviderUser) {
        guard  let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let token = UserDefaults.standard.retrieve(object: String.self, fromKey: UserDefaultsKey.FcmToken) ?? ""
           let ref = Firestore.firestore()
           let usersReference = ref.collection("users").document(uid)
        let user = User(id: uid, userName: user.userName ?? "", firstName: user.firstName ?? "", lastName: user.lastName ?? "", email: user.email ?? "", imgUrl: user.imgUrl ?? "", friends: [], fdsRequest: [], fdsPending: [], fcmToken: token, userType: "real", owner: uid, yearBalance: [2020:0])
        user.save().then { _ in
            print("success save")
        } 
       }
    
    
   
    
    static func updateDisplayName(_ providerUser:ProviderUser) {
        guard let user = Auth.auth().currentUser else { return }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = providerUser.userName as! String
        changeRequest.photoURL = URL(fileURLWithPath: providerUser.imgUrl as! String)
        changeRequest.commitChanges(completion: { (error) in
            if let _ = error {
                return
            }
            print("Updated Display Name & Img Pic")
        })
      }
    
}
