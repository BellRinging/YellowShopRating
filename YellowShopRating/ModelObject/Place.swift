//
//  Place.swift
//  YellowShopRating
//
//  Created by Kwok Wai Yeung on 12/6/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import Firebase
import Promises
import FirebaseFirestore

struct Place: Codable ,Identifiable {
    var id : String
    var name : String
    var coordinatesLat : Double
    var coordinatesLong : Double
    var openRiceLink : String
    var googleLocationLat : Double
    var googleLocationLong : Double
    var googleName : String
    var googleRating : Double
    var googleTotalRating : Int
    var openRiceGood : Int
    var openRiceOk : Int
    var openRiceBad : Int
//    var openRiceError : Bool
    var openRiceCategorys : [String]
    var category : String
    var distance : Double?
    var distanceOnClick : Double?
    var averageRate : Double?
    var googlePlaceId : String?
    var googleStatus : Int  //0 = non Exist 1 = Exist , 2 = Exist but not nearby
    var openRiceStatus : Int
    var openRiceAddr : String?
}


extension Place {
    
    
    func delete() -> Promise<Void> {
        let p = Promise<Void> { (resolve , reject) in
            let db = Firestore.firestore()
            db.collection("places").document(self.id).delete { (err) in
                guard err == nil  else {
                     return reject(err!)
                 }
                print("delete place: \(self.id)")
                return resolve(())
            }
        }
        return p
    }
    
    static func getAllItem() -> Promise<[Place]> {
        let p = Promise<[Place]> { (resolve , reject) in
            let db = Firestore.firestore()
            let ref = db.collection("places")
//                .whereField("existInGoogle", isEqualTo: false)
            var groups : [Place] = []
            
            ref.getDocuments { (snap, err) in
                guard let documents = snap?.documents else {return}
                for doc in documents {
                    do {
                        
                        let data = try JSONSerialization.data(withJSONObject: doc.data(), options: .prettyPrinted)
                        let  group = try JSONDecoder.init().decode(Place.self, from: data)
                        
                        groups.append(group)
                    }catch{
                        print(error)
                        print(doc.data())
                        reject(error)
                    }
                }
                resolve(groups)
            }
        }
        return p
    }
    

    func save() -> Promise<Place> {
             
          return Promise<Place> { (resolve , reject) in
              let db = Firestore.firestore()
              let encoded = try! JSONEncoder.init().encode(self)
              let data = try! JSONSerialization.jsonObject(with: encoded, options: .allowFragments)
              let ref = db.collection("places").document(self.id)
//            print("id",self.id)
              ref.setData(data as! [String : Any]) { (err) in
                  guard err == nil  else {
                    print(err?.localizedDescription)
                      return reject(err!)
                  }
                print("Saved \(self.name)")
                  resolve(self)
              }
          }
      }
}


