//
//  SearchView.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 17/3/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI


struct FilterView: View {
    
    @ObservedObject var viewModel: FilterViewModel
    
    init(filterSetting: Binding<AppSetting> , closeFlag : Binding<Bool>,categoryList : [String]){
        viewModel = FilterViewModel(filterSetting: filterSetting,closeFlag: closeFlag , categoryList : categoryList)
        
    }
    
    var body: some View {
        NavigationView {
            VStack{
            Form {
                HStack {
                    Picker(selection: $viewModel.pageSetting.selectedOnlyHighRate,
                           label: Text("OnlyHighRate"),
                           content: {
                            ForEach(0 ..< self.viewModel.pageSetting.OnlyHighRate.count,id: \.self) {
                                Text(self.viewModel.pageSetting.OnlyHighRate[$0]).tag($0)
                            }
                    })
                }
                HStack {
                    Picker(selection: $viewModel.pageSetting.selectedDistance,
                           label: Text("Distance"),
                           content: {
                            ForEach(0 ..< self.viewModel.pageSetting.distances.count,id: \.self) {
                                Text(self.viewModel.pageSetting.distances[$0]).tag($0)
                            }
                    })
                }
                HStack {
                    Picker(selection: $viewModel.pageSetting.selectedCategory,
                           label: Text("Categorys"),
                           content: {
                            ForEach(0 ..< self.viewModel.categoryList.count,id: \.self) {
                                Text(self.viewModel.categoryList[$0]).tag($0)
                            }
                    })
                }
                HStack {
                    Picker(selection: $viewModel.pageSetting.selectedGoogleRate,
                           label: Text("Google Rate"),
                           content: {
                            ForEach(0 ..< self.viewModel.pageSetting.googleRate.count,id: \.self) {
                                Text(self.viewModel.pageSetting.googleRate[$0]).tag($0)
                            }
                    })
                }
                HStack {
                    Picker(selection: $viewModel.pageSetting.selectedGoogleReviewCount,
                           label: Text("Google Review Number"),
                           content: {
                            ForEach(0 ..< self.viewModel.pageSetting.googleReviewCount.count,id: \.self) {
                                Text(self.viewModel.pageSetting.googleReviewCount[$0]).tag($0)
                            }
                    })
                }
                HStack {
                    Picker(selection: $viewModel.pageSetting.selectedOpenRiceRate,
                           label: Text("OpenRice Rate"),
                           content: {
                            ForEach(0 ..< self.viewModel.pageSetting.openRiceRate.count,id: \.self) {
                                Text(self.viewModel.pageSetting.openRiceRate[$0]).tag($0)
                            }
                    })
                }
                HStack {
                    Picker(selection: $viewModel.pageSetting.selectedOpenRiceReviewCount,
                           label: Text("OpenRice Review Number"),
                           content: {
                            ForEach(0 ..< self.viewModel.pageSetting.openRiceReviewCount.count,id: \.self) {
                                Text(self.viewModel.pageSetting.openRiceReviewCount[$0]).tag($0)
                            }
                    })
                }
                Button(action: {
                    if self.viewModel.signInFlag == 0 {
                        withAnimation {
                            self.viewModel.showSignIn = true
                        }
                    }else{
                        self.viewModel.logout()
                    }
                }, label:{
                    HStack{
                        Spacer()
                        Text(self.viewModel.signInFlag == 0 ? "Login":"Logout").textStyle(size: 16,color: Color.red)
                        Spacer()
                    }
                })
                
            }
                Spacer()
            
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag),trailing: ConfirmButton(){
                 self.viewModel.search()
            })
        }.modal(isShowing: self.$viewModel.showSignIn) {
            LoginView(closeFlag: self.$viewModel.showSignIn,loginFlag: self.$viewModel.signInFlag)
        }
    }
}

