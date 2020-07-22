import UIKit


public struct ProviderUser : Codable {
    var userName: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var imgUrl : String?
    
    init() {
        userName=""
        firstName=""
        lastName=""
        email=""
        imgUrl=""
    }
    
    init(userName: String?,
    firstName: String?,
    lastName: String?,
    email: String?,
    imgUrl: String?) {
        self.userName = userName
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.imgUrl = imgUrl
        
    }
}
