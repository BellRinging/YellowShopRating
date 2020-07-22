//
//  SearchView.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI


struct ListView: View {
    
     @ObservedObject var viewModel: ListViewModel
    
    init(closeFlag : Binding<Bool>,places : [Place]){
        viewModel = ListViewModel(closeFlag: closeFlag , places : places)
    }
    
    var body: some View {
        
        List{
            ForEach(self.viewModel.places) { place in
                VStack{
                    HStack{
                        Text(place.name).bold()
                        Spacer()
                        Text(String(format: "%.0f M", place.distance ?? 0)).textStyle(size: 12 , color: Color.red)
                    }
                    HStack{
                        Text(place.openRiceCategorys.joined(separator:" ")).textStyle(size: 12)
                        Spacer()
                    }
                    HStack{
                        Text(String(format: "%.1f", place.googleRating)).textStyle(size: 12)
                        Text("\(place.googleTotalRating)").textStyle(size: 12)
                        Text("OR:\(place.openRiceGood)/\(place.openRiceOk)/\(place.openRiceBad)").textStyle(size: 12)
                        Spacer()
                    }
                }
                    
                .contentShape(Rectangle())
                .onTapGesture {
                    self.viewModel.closeFlag.toggle()
                    NotificationCenter.default.post(name: .locatePlace,object: place )
                }
            }
            
        }

    }
    
 
    

}

