//
//  SearchPlaceResult.swift
//  YellowShopRating
//
//  Created by Kwok Wai Yeung on 26/6/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct SearchPlaceResult: View {
    
    @Binding var places : [Place]
    @Binding var searchTerm : String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
//            if places.filter {$0.name.localizedStandardContains(self.searchTerm)} == 0 {
//            }else{
                List{
                    ForEach(places.filter {
                        self.searchTerm.isEmpty ? false : $0.name.localizedStandardContains(self.searchTerm)
                    }) { place in
                        HStack{
                            Text(place.name)
                            Spacer()
                        }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.searchTerm = ""
                                NotificationCenter.default.post(name: .locatePlace,object: place )
                                UIApplication.shared.endEditing()
                        }
                    }
                }
//            }
        }
        .padding(.all)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(8)
    }
    
}
