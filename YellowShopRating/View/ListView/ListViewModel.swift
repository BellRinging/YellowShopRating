//
//  SearchViewModel.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 18/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import CoreLocation

class ListViewModel: ObservableObject {
    
    @Binding var closeFlag : Bool
    @Published var places : [Place] = []
        
    init(closeFlag : Binding<Bool>, places : [Place]) {
        self._closeFlag = closeFlag
        self.places = sortByDistance(places:places)
    }
    
    func sortByDistance(places : [Place]) -> [Place] {
        var result : [Place] = []
        for var place in places {
            if let location = Utility.currentLocation {
                let aLoc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                var bLoc :  CLLocation
                if place.googleStatus == 1 {
                    bLoc = CLLocation(latitude: place.googleLocationLat, longitude: place.googleLocationLong)
                }else{
                    bLoc = CLLocation(latitude: place.coordinatesLat, longitude: place.coordinatesLong)
                }
                place.distance = aLoc.distance(from: bLoc)
                result.append(place)
            }
        }
        result = result.sorted{ $0.distance ?? 0 < $1.distance ?? 0}
        return result
    }
    
}
