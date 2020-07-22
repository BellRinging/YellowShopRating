//
//  ContentView.swift
//  YellowShopRating
//
//  Created by Kwok Wai Yeung on 12/6/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    @State private var searchBarHeight: CGFloat = 0
    @State private var searchTerm : String = ""
    
    init(){
        viewModel = MainViewModel()
    }
    
    
    func overLay() -> some View{
        VStack(alignment: .center){
            HStack(alignment: .center, spacing: 0){
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .resizable().scaledToFit().frame(width:30).foregroundColor(Color.gray)
                    .onTapGesture {
                        self.viewModel.showFilter = true
                }.padding(.leading)
                
                SearchBar(text: $searchTerm, keyboardHeight: $searchBarHeight, placeholder: "Search for a restaurant")
                Image(systemName: "list.dash")
                    .resizable().scaledToFit().frame(width:30).foregroundColor(Color.gray)
                    .onTapGesture {
                        self.viewModel.showListView.toggle()
                }.padding(.trailing)
            }
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
            
                
            if searchTerm != "" {
                SearchPlaceResult(places: self.$viewModel.originalList,searchTerm: $searchTerm)
                    .padding(.horizontal)
                    .padding(.bottom, searchBarHeight)
            }
            
            if self.viewModel.showListView && searchTerm == "" {
                ListView(closeFlag: self.$viewModel.showListView, places: self.viewModel.places)
                    .padding(.horizontal)
//                    .padding(.bottom, searchBarHeight)
            }
            Spacer()
            Button(action: {
                self.viewModel.getAllOpenRices()
            }) {
                Text("Update OR")
            }
        }
    }
    
    var body: some View {
        ZStack{
            VStack{
                MapView()
                    .edgesIgnoringSafeArea(.top)
                    .overlay(self.overLay())
            }
            VStack{
                Spacer()
                if self.viewModel.selection != nil {
                    PlaceDetailView(place: self.viewModel.selection!, location: Utility.currentLocation){
                        NotificationCenter.default.post(name: .clearPlace,object: nil )
                    }.frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10).padding(.all,5)
                        .opacity(0.95)
                }
            }
        }
        .modal(isShowing: self.$viewModel.showFilter) {
            FilterView(filterSetting: self.$viewModel.filterSetting,closeFlag: self.$viewModel.showFilter,categoryList: self.viewModel.distinctCategorys)
        }
    }
}

