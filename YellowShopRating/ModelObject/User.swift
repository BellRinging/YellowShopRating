import UIKit
import Firebase
import Promises
import FirebaseFirestore
import FirebaseAuth

struct User : Identifiable,Codable,Equatable,Hashable  {
//    let id = UUID()
    public var  id : String
    public var  userName: String
    public var  firstName: String?
    public var  lastName: String?
    public var  email: String
    public var  imgUrl : String
//    public var  balance : Int
    public var  friends: [String]
    public var  fdsRequest: [String]
    public var  fdsPending: [String]
    public var  fcmToken: String
    public var  userType: String
    public var  owner: String
    public var  yearBalance: [Int:Int]
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.email == rhs.email
    }
}


extension User {
    
    func delete() -> Promise<Void> {
        let p = Promise<Void> { (resolve , reject) in
            let db = Firestore.firestore()
            db.collection("users").document(self.id).delete { (err) in
                guard err == nil  else {
                     return reject(err!)
                 }
                print("delete user: \(self.id)")
                return resolve(())
            }
        }
        return p
    }
    
    
    
    static func getUserObject() -> Promise<User?>  {
        let p = Promise<User?>{(resolve , reject) in
            if true {
                resolve(nil)
            }else{
                let err = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "User not yet login"])
                reject(err)
            }
        }
        if let user = Auth.auth().currentUser{
            return self.getById(id: "")
        }else{
            return p
        }
     }

    
    static func searchUserByEmail(text: String) -> Promise<[User]>  {
        var endText = text + "z"
          let p = Promise<[User]> { (resolve , reject) in
              let db = Firestore.firestore()
            let ref = db.collection("users").whereField("email", isGreaterThanOrEqualTo: text).whereField("email", isLessThan: endText)
            ref.getDocuments { (snap, err) in
                guard let documents = snap?.documents else {return}
                var groups : [User] = []
                for doc in documents {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        let  group = try JSONDecoder.init().decode(User.self, from: data)
                        groups.append(group)
                    }catch{
                        reject(error)
                    }
                }
                resolve(groups)
          }
      }
        return p
    }
    
    
    static func searchUserByName(text: String) -> Promise<[User]>  {
        var endText = text + "z"
          let p = Promise<[User]> { (resolve , reject) in
              let db = Firestore.firestore()
            let ref = db.collection("users").whereField("email", isGreaterThanOrEqualTo: text).whereField("email", isLessThan: endText)
            ref.getDocuments { (snap, err) in
                guard let documents = snap?.documents else {return}
                var groups : [User] = []
                for doc in documents {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        let  group = try JSONDecoder.init().decode(User.self, from: data)
                        groups.append(group)
                    }catch{
                        reject(error)
                    }
                }
                resolve(groups)
          }
      }
        return p
    }
    
    
    static func getById(id: String) -> Promise<User?>  {
        let p = Promise<User?> { (resolve , reject) in
            let db = Firestore.firestore()
            var ref = db.collection("users").document(id)
//            print(ref.path)
            ref.getDocument { (snapshot, err) in
                if let err = err{
//                    print(err)
                    reject(err)
                }
                 
                guard let dict = snapshot?.data() else {
                    print("No User found :\(id)")
                    resolve(nil)
                    return
                }
//                print("i3")
                do {
                    let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    let group = try JSONDecoder.init().decode(User.self, from: data)
                    resolve(group)
                }catch{
                    reject(error)
                }
//                print("i4")
            }
        }
        return p
    }
    
    func updateFcmToken(token:String) -> Promise<User> {
        return Promise<User> { (resolve , reject) in
            let db = Firestore.firestore()
            let data = ["fcmToken" : token]
            let ref = db.collection("users").document(self.id)
            ref.updateData(data) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
            }
            print("Update fcmtoken for \(self.id)")
            resolve(self)
        }
    }
    
    
 
    static func getAllItem() -> Promise<[User]> {
        let p = Promise<[User]> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("users")
            var groups : [User] = []
            
            ref.getDocuments { (snap, err) in
                guard let documents = snap?.documents else {return}
                for doc in documents {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        let  group = try JSONDecoder.init().decode(User.self, from: data)
                        groups.append(group)
                    }catch{
                        reject(error)
                    }
                }
                resolve(groups)
            }
        }
        return p
    }
    
    
    
    func save() -> Promise<User> {
           
        return Promise<User> { (resolve , reject) in
            let db = Firestore.firestore()
            let encoded = try! JSONEncoder.init().encode(self)
            let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
            let ref = db.collection("users").document(self.id)
            ref.setData(data as! [String : Any]) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
                resolve(self)
            }
        }
    }
    
    func updateFriend(userId:String) -> Promise<User> {
        return Promise<User> { (resolve , reject) in
            let db = Firestore.firestore()
            let data = ["friends" : FieldValue.arrayUnion([userId])]
            let ref = db.collection("users").document(self.id)
            ref.updateData(data) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
            }
            print("Update friends array add \(userId) to \(self.id)")
            resolve(self)
        }
    }
    
    func updateFdsRequest(userId:String) -> Promise<User> {
        return Promise<User> { (resolve , reject) in
            let db = Firestore.firestore()
            let data = ["fdsRequest" : FieldValue.arrayUnion([userId])]
            let ref = db.collection("users").document(self.id)
            ref.updateData(data) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
            }
            print("Update updateFdsRequest array add \(userId) to \(self.id)")
            resolve(self)
        }
    }
    
    func removeFdsRequest(userId:String) -> Promise<User> {
        return Promise<User> { (resolve , reject) in
            let db = Firestore.firestore()
            let data = ["fdsRequest" : FieldValue.arrayRemove([userId])]
            let ref = db.collection("users").document(self.id)
            ref.updateData(data) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
            }
            print("Update updateFdsRequest array add \(userId) to \(self.id)")
            resolve(self)
        }
    }
    
    func removeFdsPending (userId:String) -> Promise<User> {
        return Promise<User> { (resolve , reject) in
            let db = Firestore.firestore()
            let data = ["fdsPending" : FieldValue.arrayRemove([userId])]
            let ref = db.collection("users").document(self.id)
            ref.updateData(data) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
            }
            print("Update fdsPending array add \(userId) to \(self.id)")
            resolve(self)
        }
    }
    
    func updateFdsPending (userId:String) -> Promise<User> {
        return Promise<User> { (resolve , reject) in
            let db = Firestore.firestore()
            let data = ["fdsPending" : FieldValue.arrayUnion([userId])]
            let ref = db.collection("users").document(self.id)
            ref.updateData(data) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
            }
            print("Update fdsPending array add \(userId) to \(self.id)")
            resolve(self)
        }
    }


    func updateBalance(value : Int ,year : Int,absoluteValue : Bool = false) -> Promise<User>{
        return Promise<User> { (resolve , reject) in
            let db = Firestore.firestore()
            var data : [String : Any]
            if absoluteValue {
                data = ["yearBalance.\(year)": value]
            }else{
                data = ["yearBalance.\(year)": FieldValue.increment(Int64(value))]
            }
            let ref = db.collection("users").document(self.id)
            ref.updateData(data as [String : Any]) { (err) in
                guard err == nil  else {
                    return reject(err!)
                }
                print("Update balance \(self.id) \(value)")
                resolve(self)
            }
        }
    }
}

