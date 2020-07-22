//
//  YellowModel.swift
//  YellowShopRating
//
//  Created by Kwok Wai Yeung on 12/6/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Kanna
import GoogleSignIn
import FirebaseAuth
import Combine
import GoogleMaps
import GooglePlaces
import CoreLocation
import Promises

class MainViewModel: ObservableObject {
    
    let session = URLSession(configuration: .default)
    var googlePlacesKey: String = "AIzaSyCsxDhr6tzn1PevbYTlhOqBRl9RhkQxX_8"
    private var tickets: [AnyCancellable] = []
    @Published var places : [Place] = []
    @Published var selection : Place? = nil
    @Published var originalList :  [Place] = []
    @Published var showFilter :  Bool = false
    @Published var showListView :  Bool = false
    var distinctCategorys : [String] = []
    @Published var filterSetting: AppSetting = AppSetting(){
        didSet{
            print("Call refresh")
            refreshList()
        }
    }
    var promisesList : [Promise<Place>] = []
    
    init(){
        self.getAllitem()
        NotificationCenter.default.publisher(for: .selectPlace)
            .map{$0.object as! Place }
            .sink { [unowned self] place in
                withAnimation {
                    self.selection = place
                }
        }.store(in: &tickets)
        NotificationCenter.default.publisher(for: .clearPlace)
            .sink { [unowned self] _ in
                withAnimation {
                    
                    self.selection = nil
                }
        }.store(in: &tickets)
        
        NotificationCenter.default.publisher(for: .locatePlace)
            .map{$0.object as! Place }
            .sink { place in
                if let abc = self.places.firstIndex{ $0.name == place.name && $0.coordinatesLong == place.coordinatesLong} {
                }else{
                    self.places.append(place)
                }                
        }.store(in: &tickets)
    }
    
    
    
    
    func convertOpenRice(place:Place,data : String,count: Int){
//        meta[property='al:android:url']
        if let doc = try? HTML(html: data, encoding: .utf8) {
            let ratings =  doc.css("div .score-div")
            let category = doc.css(".header-poi-categories")
            let address = doc.css(".address-info-section")
            if ratings.count == 3 {
                var temp = place
                temp.openRiceStatus = 1
                temp.openRiceGood = Int(ratings[0].text ?? "")!
                temp.openRiceOk = Int(ratings[1].text ?? "")!
                temp.openRiceBad = Int(ratings[2].text ?? "")!
                temp.name = temp.name.trimmingCharacters(in: .whitespaces)
                let addrText = address.count > 0 ? address[0].text ?? "" : ""
                temp.openRiceAddr = addrText.replacingOccurrences(of: "地址", with: "").trimmingCharacters(in: .whitespaces)
                temp.openRiceCategorys = category.first?.text?.components(separatedBy: CharacterSet(charactersIn: "\n\r")).filter{$0.trimmingCharacters(in: .whitespaces) != ""}.map{ $0.trimmingCharacters(in: .whitespaces) } ?? []
                if (temp.openRiceCategorys.contains("All")){
                    print(category.first?.text)
                }
                temp.save()
            }else{
                var temp = place
                temp.openRiceStatus = 2
                temp.openRiceCategorys = []
                temp.name = temp.name.trimmingCharacters(in: .whitespaces)
                temp.openRiceGood = 0
                temp.openRiceOk = 0
                temp.openRiceBad = 0
                temp.openRiceAddr = ""
                temp.save()
            }
        }
    }
    
    func getOpenRice(place:Place,url : String ,count:Int){
        let url = URL(string: url.trimmingCharacters(in: .whitespaces))!
        let abc = URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let anError):
        
                    if anError.code.rawValue == -1001 {
                        print("error retryon 5s ",count)
                        self.background.asyncAfter(deadline: .now() + 5) {
                            self.getOpenRice(place:place,url : url.absoluteString ,count:count)
                        }
                    }else{
                        print("Other error",anError.code)
                    }
                }
            }) { data in
                    let str = String(decoding: data, as: UTF8.self)
                    self.convertOpenRice(place:place,data: str ,count: count)
            }
            self.tickets.append(abc)
    }
        
    func covert(data : String){
        var revisedData = data.replacingOccurrences(of: "]]>", with: "")
        revisedData = revisedData.replacingOccurrences(of: "<![CDATA[", with: "")
        print("Replaced <![CDATA[ ]]")
        
        if let doc = try? HTML(html: revisedData, encoding: .utf8) {
            var places : [Place] = []
            var newCount : Int = 0
            let yellowRestaurants = doc.xpath("//folder[name='黃色商戶_Eat']/placemark")
            print("Search for 黃色商戶_Eat " , yellowRestaurants.count)
            for place in  yellowRestaurants {
                var name = place.css("name").first?.text ?? ""
                if name == "" {
                    print("no name so skiped " , place.innerHTML)
                    continue
                }
                var desc = place.css("description").first?.text ?? ""
                let coordinates = place.css("coordinates").first?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                let split = coordinates?.split(separator: ",")
                let x = Double(split![0])!
                let y = Double(split![1])!
                let uid = UUID().uuidString
                
                let descSplit = desc.components(separatedBy: ":")
                
                var category : String = ""
                
                var openRiceLink : String = ""
                for item in descSplit {
                    if item.contains(".openrice."){
                        openRiceLink = "https:" + item.replacingOccurrences(of: "原因", with: "")
                        break
                    }
                }
                
                var getNextItem : Bool = false
                for item in descSplit {
                
                    if getNextItem {
                        category = item.replacingOccurrences(of: "地址", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                        break
                    }
                    if item.contains("類別"){
                        getNextItem = true
                    }
                }
                
                let openRiceStatus = openRiceLink == "" ? 0 : 1
                let checkPlaceExist = originalList.first{$0.name == name && $0.coordinatesLong == x}
                if checkPlaceExist != nil{
                    print("skip")
                }else{
                    newCount += 1
                    var obj = Place(
                         id: uid, name: name, coordinatesLat: y, coordinatesLong: x, openRiceLink:openRiceLink, googleLocationLat: 0, googleLocationLong: 0, googleName: "", googleRating: 0, googleTotalRating: 0,openRiceGood: 0,openRiceOk:0,
                                    openRiceBad: 0,
                                    openRiceCategorys: [],category:category ,googleStatus: 1,openRiceStatus: openRiceStatus)
                    
                    places.append(obj)
                }
            }
            print("Get record" , places.count , "New",newCount)
            var list : [Promise<Place>] = []
            for i in places{
                
                print(i.name,i.category ,i.openRiceLink)
                list.append(i.save())
            }
            Promises.all(list).then { _ in
                print("Completed")
                Utility.hideProgress()
            }
        }
    }
    
    lazy var background: DispatchQueue = {
        return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
    }()
    
    func arrayFromContentsOfFileWithName(fileName: String) -> [String]? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt") else {
            return nil
        }

        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            return content.components(separatedBy: "\n")
        } catch {
            return nil
        }
    }
    
    func getAllOpenRices(){
        Utility.showProgress()
        self.promisesList = []
        self.background.async {
            print("Total",self.originalList.count)
            var count : Int = 1
            for var place in self.originalList{
                if place.openRiceStatus == 1 {
                    count += 1
                    self.getOpenRice(place: place,url: place.openRiceLink ,count: count)
                }else{
                    place.openRiceAddr = ""
                    place.name = place.name.trimmingCharacters(in: .whitespaces)
                    place.save()
                }
            }
            print("count: ",count)
            Utility.hideProgress()
        }
    }
    
    
    func getAllitem2(){
        self.background.async {
            var result : [Place] = []
            var find = 0
            var notFound = 0
            var noNearBy = 0
            for var place in self.originalList{
                let url = self.googlePlacesDataURL(place: place)
                
                let ticket = URLSession.shared.dataTaskPublisher(for: url)
                    .map { $0.data }
                    .decode(type: GooglePlacesResponse.self, decoder: JSONDecoder())
                    .map{$0.candidates}
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let anError):
                            print("received error: ", anError)
                            print(place)
                        }
                    }) { places in
                        let places = places.filter{ $0.businessStatus != "CLOSED_PERMANENTLY" }
                        if places.count == 0  {
                            notFound += 1
                            print("cant find in google")
                            print(place.name)
                            print(url)
                            place.googleStatus = 0
                            place.googlePlaceId = ""
                            place.googleLocationLat = 0
                            place.googleLocationLong = 0
                            place.googleRating = 0
                            place.googleTotalRating = 0
                            place.googleName = ""
                            place.save()
                        }else if places.count == 1  {
                            find += 1
                            let temp = places[0]
                            place.googleStatus = 1
                            place.googlePlaceId = temp.placeId
                            place.googleLocationLat = temp.geometry.location.latitude
                            place.googleLocationLong = temp.geometry.location.longitude
                            place.googleRating = temp.rating
                            place.googleName = temp.name
                            place.googleTotalRating = temp.ratingTotal
                            place.save()
                        }else{
                            var mostNearby : GooglePlace = places[0]
                            let mostNearbyCord = mostNearby.geometry.location
                            let placeLocation = CLLocation(latitude: place.coordinatesLat, longitude: place.coordinatesLong)
                            let mostNearbyLoc = CLLocation(latitude: mostNearbyCord.latitude, longitude: mostNearbyCord.longitude)
                            var mostNearbyDistance = placeLocation.distance(from: mostNearbyLoc)
                            for abc in places {
                                let cord = abc.geometry.location
                                let aLoc = CLLocation(latitude: cord.latitude, longitude: cord.longitude)
                                let bLoc = CLLocation(latitude: place.coordinatesLat, longitude: place.coordinatesLong)
                                let distance = aLoc.distance(from: bLoc)
                                if distance < mostNearbyDistance{
                                    mostNearby = abc
                                    mostNearbyDistance = distance
                                }
                            }
                            if mostNearbyDistance < 150 {
                                find += 1
                                place.googleStatus = 1
                                place.googleLocationLat = mostNearby.geometry.location.latitude
                                place.googleLocationLong = mostNearby.geometry.location.longitude
                                place.googlePlaceId = mostNearby.placeId
                                place.googleRating = mostNearby.rating
                                place.googleName = mostNearby.name
                                place.googleTotalRating = mostNearby.ratingTotal
                                place.save()
                            }else{
                                noNearBy += 1
                                place.googleStatus = 2
                                place.googlePlaceId = ""
                                place.googleLocationLat = 0
                                place.googleLocationLong = 0
                                place.googleRating = 0
                                place.googleTotalRating = 0
                                place.googleName = ""
                                place.save()
                                print("no nearby:" , place.name,mostNearbyDistance)
                                print(url)
                            }
                        }
                }
                
                self.tickets.append(ticket)
            }
            print("find" , find)
            print("notFound" , notFound)
            print("noNearBy" , noNearBy)
        

        }
 
    }
    
    
    func getAllitem(){
        var result : [Place] = []
        Place.getAllItem().then { places in
            print("Restaurant Count",places.count)
            self.originalList = places
            self.getDistinctCategory()
            self.refreshList()
        }
    }
    
    func getAverageRate(place:Place) ->Double{
        var gRate : Double = 0
        var oRate : Double = 0
        
        if place.googleStatus == 1 {
            gRate = place.googleRating
        }
        
        if place.openRiceStatus == 1 {
            gRate = (Double(place.openRiceGood + place.openRiceOk  ) / Double(place.openRiceGood   + place.openRiceOk + place.openRiceBad )) / 2 * 10
        }
        
        return gRate > oRate ? gRate : oRate
    }
    
    func getDistinctCategory(){
        self.distinctCategorys = []
        distinctCategorys.append("Any")
        var result : [Place] = []
         
        for var place in self.originalList{
            place.averageRate = self.getAverageRate(place: place)
            result.append(place)
            for category in place.openRiceCategorys{
                if !distinctCategorys.contains(category){
                    distinctCategorys.append(category)
                }
            }
        }
        self.originalList = result
    }
    
    
    func refreshList(){
        var result : [Place] = self.originalList
        print("refresh1",result.count)
        
        if self.filterSetting.selectedDistance != 0 {
            var temp : [Place] = []
            for place in self.originalList{
                if let location = Utility.currentLocation {
                    let aLoc = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    var bLoc : CLLocation
                    if place.googleStatus == 1 {
                        bLoc = CLLocation(latitude: place.googleLocationLat, longitude: place.googleLocationLong)
                    }else{
                        bLoc = CLLocation(latitude: place.coordinatesLat, longitude: place.coordinatesLong)
                    }                    
                    let distance = aLoc.distance(from: bLoc)
                    let selectedDistance = self.filterSetting.selectedDistanceValue
                    if distance < selectedDistance  {
                        temp.append(place)
                    }
                }
            }
            result = temp
            print("Filter Distinct",result.count)
        }
        
        
        if self.filterSetting.selectedOnlyHighRate == 0 {
            var temp : [Place] = []
            for place in result {
                if place.googleRating > 4 && place.googleTotalRating > 50 {
                    temp.append(place)
                }else {
                    let total = place.openRiceGood  + place.openRiceOk   + place.openRiceBad
                    let first2 = place.openRiceGood  + place.openRiceOk
                    if total > 50 && Double(first2)/Double(total) > 0.75{
                        temp.append(place)
                    }
                }
            }
            result = temp
            print("Filter HighRate Only",result.count)
        }
        
        
        if self.filterSetting.selectedCategory != 0 {
            let selectedCategoryValue = self.distinctCategorys[self.filterSetting.selectedCategory]
            var temp : [Place] = []
            for place in result {
                let categorys = place.openRiceCategorys
                if categorys.contains(selectedCategoryValue){
                    temp.append(place)
                }
            }
            result = temp
            print("Filter Category Only",result.count)
        }
        
        
        if self.filterSetting.selectedGoogleRate != 0 {
            var temp : [Place] = []
            for place in result {
                if place.googleRating > self.filterSetting.selectedGoogleRateValue  {
                    temp.append(place)
                }
            }
            result = temp
            print("Filter GoogleRate",result.count)
        }
        
        
        if self.filterSetting.selectedGoogleReviewCount != 0 {
                  var temp : [Place] = []
                  for place in result {
                    if place.googleTotalRating > self.filterSetting.selectedGoogleReviewCountValue  {
                          temp.append(place)
                      }
                  }
                  result = temp
                  print("Filter GoogleTotalReview",result.count)
              }
        
        if self.filterSetting.selectedOpenRiceReviewCount != 0 {
            var temp : [Place] = []
            for place in result {
                let total = place.openRiceGood + place.openRiceOk + place.openRiceBad
                if total > self.filterSetting.selectedOpenRiceReviewCountValue  {
                    temp.append(place)
                }
            }
            result = temp
            print("Filter GoogleTotalReview",result.count)
        }
        
        
        if self.filterSetting.selectedOpenRiceRate != 0 {
            var temp : [Place] = []
  
            for place in result {
                let total = (place.openRiceGood ?? 0) + (place.openRiceOk ?? 0)  + (place.openRiceBad ?? 0)
                let first2 = (place.openRiceGood ?? 0) + (place.openRiceOk ?? 0)
                if  Double(first2)/Double(total) > self.filterSetting.selectedOpenRiceRateValue {
                    temp.append(place)
                }
            }
            result = temp
            print("Filter OpenRiceRate",result.count)
        }
        self.places = result
        NotificationCenter.default.post(name: .updateMarker,object: self.places )
    }
        
        
    
    func GrabData(){
        let mapId = "1y44FzG0yy2qK_IPOotMg06ckh_ypZoJW"
        let url = URL(string: "https://www.google.com/maps/d/kml?mid=\(mapId)&forcekml=1")!
        Utility.showProgress()
        self.background.async {
            
            let abc = URLSession.shared.dataTaskPublisher(for: url)
                .map{$0.data}
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let anError):
                        print("received error: ", anError)
                        Utility.showAlert(message: anError.localizedDescription)
                        Utility.hideProgress()
                    }
                }) { data in
                    print("Get The data")
                    let str = String(decoding: data, as: UTF8.self)
                    self.covert(data: str)
            }
            self.tickets.append(abc)
        }
    }
    
    func logout(){
        try! Auth.auth().signOut()
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.LoginFlag)
        NotificationCenter.default.post(name: .dismissMainView ,object: nil)
        print("Completed logout")
    }
    


     
     // create the URL to request a JSON from Google
     func googlePlacesDataURL(place: Place) -> URL {
        let baseURL = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?"
        let locationString = "locationbias=circle:10@\(place.coordinatesLat),\(place.coordinatesLong)"
        let fields = "fields=place_id,business_status,name,rating,geometry/location,user_ratings_total"
        let inputType = "inputtype=textquery"
        let type = "type=restaurant"
        let language = "language=zh_hk"
        let keywrd = "input=" + place.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let key = "key=" + googlePlacesKey
         return URL(string: baseURL +  language + "&"  + fields   + "&" + inputType + "&" + keywrd + "&" + key + "&" + locationString + "&" + type)!
     }
    
    func correct(){
        for var place in originalList {
            if place.openRiceCategorys == nil {

                place.openRiceCategorys = []
//                place.save().then{ _ in
//                    print("complete")
//                }
            }
        }
    }
}


extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        print("inside 1")
         
    return dataTask(with: url) { (data, response, error) in
        print("inside datatask")
        if let error = error {
            result(.failure(error))
            return
        }
        guard let response = response, let data = data else {
            let error = NSError(domain: "error", code: 0, userInfo: nil)
            result(.failure(error))
            return
        }
        result(.success((response, data)))
    }
}
}



struct AppSetting {
    var selectedOnlyHighRate:Int = 1
    var selectedDistance:Int = 3
    var selectedCategory:Int = 0
    var selectedGoogleRate:Int = 0
    var selectedGoogleReviewCount:Int = 0
    var selectedOpenRiceReviewCount:Int = 0
    var selectedOpenRiceRate:Int = 0
    
    var OnlyHighRate : [String] = ["Yes","No"]
    var distances : [String] = ["Any","500","1000","2000","5000","10000","20000","50000"]
    var googleRate : [String] = ["Any","3","4","4.2","4.5","5"]
    var googleReviewCount : [String] = ["Any","20","50","100","150","200","300","500"]
    var openRiceRate : [String] = ["Any","0.5","0.6","0.7","0.75","0.8","0.85","0.9"]
    var openRiceReviewCount: [String] = ["Any","20","50","100","150","200","300","500"]
    
    
    var selectedOpenRiceReviewCountValue : Int {
        return Int(openRiceReviewCount[selectedOpenRiceReviewCount]) ?? 0
    }
    
    var selectedGoogleReviewCountValue : Int {
        return Int(googleReviewCount[selectedGoogleReviewCount]) ?? 0
    }
    
    var selectedDistanceValue : Double {
        return Double(distances[selectedDistance]) ?? 0
    }
    
    var selectedGoogleRateValue : Double {
        return Double(googleRate[selectedGoogleRate]) ?? 0
    }
    
    var selectedOpenRiceRateValue : Double {
        return Double(openRiceRate[selectedOpenRiceRate]) ?? 0
    }

}
