import Foundation
import CoreLocation

import Foundation
struct GooglePlacesResponse : Codable {
    let candidates : [GooglePlace]
}
struct GooglePlace : Codable {
    let geometry : Location
    let name : String
    let rating : Double
    let ratingTotal : Int
    let businessStatus : String
    let placeId : String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case rating = "rating"
        case ratingTotal = "user_ratings_total"
        case geometry = "geometry"
        case businessStatus = "business_status"
        case placeId = "place_id"
        
    }
    struct Location : Codable {
        let location : LatLong
        enum CodingKeys: String, CodingKey {
            case location = "location"
        }

        struct LatLong: Codable {

            let latitude : Double
            let longitude : Double
            enum CodingKeys : String, CodingKey {
                case latitude = "lat"
                case longitude = "lng"
            }
        }
    }
}
