//
//  PlaceDetailView.swift
//  YellowShopRating
//
//  Created by Kwok Wai Yeung on 22/6/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import CoreLocation
import StarView

struct PlaceDetailView: View {
    
    typealias HHHHH = () -> ()
    var name : String
    var googleRate : Double
    var googleTotal : Int
    var openRiceGood : Int
    var openRiceOk : Int
    var openRiceBad : Int
    var callback : HHHHH
    var x : Double
    var y : Double
    var url : String
    var location : CLLocation?
    var distance : String
    var category : [String]
    
    init(place : Place ,location:CLLocation? ,callback:  @escaping HHHHH ){
        self.callback = callback
        if place.googleStatus == 1 {
            self.name = place.googleName
            
        }else{
            self.name = place.name
        }
        self.googleRate = place.googleRating
        self.googleTotal = place.googleTotalRating
        self.openRiceGood = place.openRiceGood ?? 0
        self.openRiceOk = place.openRiceOk ?? 0
        self.openRiceBad = place.openRiceBad ?? 0
        self.x = place.googleLocationLat
        self.y = place.googleLocationLong
        self.url = place.openRiceLink
        self.category = place.openRiceCategorys.count  > 0 ? place.openRiceCategorys : [place.category ?? ""]
        self.location = location
        if let location = location {
            let aLoc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            var bLoc : CLLocation
            if place.googleStatus == 1 {
                bLoc = CLLocation(latitude: place.googleLocationLat, longitude: place.googleLocationLong)
            }else{
                bLoc = CLLocation(latitude: place.coordinatesLat, longitude: place.coordinatesLong)
            }
            let distance = aLoc.distance(from: bLoc)
            self.distance = "\(distance.rounded()) M"
        }else{
            self.distance = "0 M"
        }
    }
    
    
    func nagButton() -> some View{
        HStack{
            Button(action: {
                UIApplication.shared.openURL(URL(string:
                    "comgooglemaps://?saddr=&daddr=\(self.x),\(self.y)&directionsmode=walking")!)
            }) {
                
                Image(systemName: "location.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .clipShape(Circle())
                    .standardImageStyle()
                    .overlay(Circle().stroke(Color.grayColor, lineWidth: 1))
                    .accentColor(Color.grayColor)
                    .shadow(radius: 5)
                
            }
            Button(action: {
                UIApplication.shared.openURL(URL(string: self.url)!)
            }) {
                Image("openRiceGray")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .standardImageStyle()
                    .shadow(radius: 5)
            }
        }
    }
    
    var body: some View {
        VStack{
            HStack{
                Text(name).bold()
                Text(distance).textStyle(size: 12)
                Spacer()
                Button(action: {
                    self.callback()
                }) {
                    Image(systemName: "xmark")
                        .accentColor(Color.red)
                        .padding(.trailing,10)
                }
            }.padding([.horizontal,.top],10)
            HStack{
                Text(category.joined(separator:" ")).textStyle(size: 12)
                Spacer()
            }.padding([.leading,.trailing],10)
            HStack{

                VStack{
                    HStack{
                        StarRatingView(starCount: 5, totalPercentage: CGFloat((googleRate / 5.0) * 100) , style: .init(borderWidth: 1, starExtrusion: 4))
                            .frame(width: 100 ,height: 10)
                        Text(String(format: "%.1f", googleRate)).textStyle(size: 20 ,color:Color.purple)
                        Text("/ \(googleTotal)").textStyle(size: 20 ,color:Color.purple)
                        Spacer()
                    }
                    HStack{
                        Image("openRiceGood").resizable().scaledToFit().frame(width: 23)
                        Text("\(openRiceGood)").textStyle(size: 20,color:Color.red)
                        Image("openRiceOk").resizable().scaledToFit().frame(width: 22)
                        Text("\(openRiceOk)").textStyle(size: 20,color:Color.red)
                            Image("openRiceSad").resizable().scaledToFit().frame(width: 20)
                            Text("\(openRiceBad)").textStyle(size: 20,color:Color.red)
                        Spacer()
                    }
                    
                }
                Spacer()
            nagButton()
            }.padding([.leading,.trailing,.bottom],10)
        }
    }
}


