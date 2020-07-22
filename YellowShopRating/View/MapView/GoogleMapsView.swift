/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that hosts an `MKMapView`.
*/

import SwiftUI
import GoogleMaps
import Combine

struct MapView: UIViewRepresentable {
    
    var location : CLLocation?
    let locationManager = CLLocationManager()
    let mapView = GMSMapView.init()
 
    

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: location?.coordinate.latitude ?? 0 ,longitude: location?.coordinate.longitude ?? 0, zoom: 15.0)
        mapView.frame = CGRect.zero
        mapView.camera = camera
        mapView.delegate = context.coordinator
        locationManager.delegate = context.coordinator
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
//        print("updateUIView")
//        uiView.animate(toLocation: CLLocationCoordinate2D(latitude: location?.coordinate.latitude ?? 0 , longitude: location?.coordinate.longitude ?? 0))
      
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(mapView)
    }
    
    final class Coordinator : NSObject , GMSMapViewDelegate ,CLLocationManagerDelegate{
        var parent : GMSMapView
        private var tickets: [AnyCancellable] = []
        var markerList : [GMSMarker] = []
        
        init(_ parent: GMSMapView){
            self.parent = parent
            super.init()
            self.addPublisher()
        }
        
        func addMarkerFromList(_ places : [Place]){
            self.parent.clear()
            self.markerList = []
            var abc = places
            abc.sort{$0.distance ?? 0 > $1.distance ?? 0}
            for place in abc{
                addMarker(place)
            }
        }
        
        func addMarker(_ place : Place ,needSelect : Bool = false){
            let marker = GMSMarker()
            var abc : CLLocationCoordinate2D? = nil
            if place.googleStatus == 1 {
                abc = CLLocationCoordinate2D(latitude: place.googleLocationLat, longitude: place.googleLocationLong)
            }else{
                abc = CLLocationCoordinate2D(latitude: place.coordinatesLat, longitude: place.coordinatesLong)
            }
            marker.position = abc!
            marker.title = place.googleStatus == 1 ? place.googleName : place.name
            let category = place.openRiceCategorys.count > 0 ? place.openRiceCategorys[0]:""
            var desc = category != "" ? "\(category)\n" : "\n"
            desc += place.googleStatus == 1 ? "G:\(place.googleRating)/\(place.googleTotalRating) \n" : ""
            desc += place.openRiceStatus == 1 ? "OR:\(place.openRiceGood )/\(place.openRiceOk )/\(place.openRiceBad) \n" : ""
            desc = desc.trimmingCharacters(in: .newlines)
            marker.snippet = desc
            marker.userData = place
            marker.map = self.parent
            marker.icon = getImageIcon(place.averageRate ?? 0)
            if needSelect {
                self.parent.selectedMarker = marker
            }
            markerList.append(marker)
        }
        
        

        
        func getImageIcon(_ rate: Double) -> UIImage{
            if rate > 4.8{
                return UIImage(named:"yellow5")!.resized(to: CGSize(width: 50, height: 50))
            }else if rate > 4.6 {
                return UIImage(named:"yellow4")!.resized(to: CGSize(width: 50, height: 50))
            }else if rate > 4.4 {
                return UIImage(named:"yellow3")!.resized(to: CGSize(width: 50, height: 50))
            }else if rate > 4.0 {
                return UIImage(named:"yellow2")!.resized(to: CGSize(width: 50, height: 50))
            }else{
                return UIImage(named:"yellow1")!.resized(to: CGSize(width: 50, height: 50))
            }
        }
        
        
        func addPublisher(){
            NotificationCenter.default.publisher(for: .updateMarker)
                .map{$0.object as! [Place]}
                .sink { places in
                    self.addMarkerFromList(places)
            }.store(in: &tickets)
            
            NotificationCenter.default.publisher(for: .clearPlace)
                .sink { _ in 
                    self.closeMarker()
                    
            }.store(in: &tickets)
            
            NotificationCenter.default.publisher(for: .locatePlace)
                .map{$0.object as! Place}
                .sink { place in
                    self.locatePlace(place: place)
                    
            }.store(in: &tickets)
        }
        
        
        func closeMarker(){
            self.parent.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        func locatePlace(place : Place){
            self.addMarker(place,needSelect: true)
            var abc : CLLocationCoordinate2D
            if place.googleStatus == 1 {
                abc = CLLocationCoordinate2D(latitude: place.googleLocationLat, longitude: place.googleLocationLong)
            }else{
                abc = CLLocationCoordinate2D(latitude: place.coordinatesLat, longitude: place.coordinatesLong)
            }
    
            self.parent.animate(toLocation: abc)
            NotificationCenter.default.post(name: .selectPlace,object: place )
            self.parent.padding = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//            print("didTag")
             UIApplication.shared.endEditing()
            let place = marker.userData as! Place
            NotificationCenter.default.post(name: .selectPlace,object: place )
            self.parent.padding = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
            
            var bounds = GMSCoordinateBounds()
            let markers = self.getNearMarker(center: place)
            for marker in markers{
                bounds = bounds.includingCoordinate(marker.position)
            }
            let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
            mapView.animate(with: update)
                
            return false
        }
        
        lazy var background: DispatchQueue = {
            return DispatchQueue.init(label: "background.queue" , attributes: .concurrent)
        }()
        
        
        func getNearMarker(center:Place) -> [GMSMarker]{
//            var places = self.markerList.map{$0.userData as! Place}
            var list = self.markerList
            for var marker in list {
                var place = marker.userData as! Place
                place.distanceOnClick = distanceFromPoint(place1:center , place2: marker.userData as! Place)
                marker.userData = place
            }
            list = list.sorted { ($1.userData as! Place).distanceOnClick ?? 0  > ($0.userData as! Place).distanceOnClick ?? 0}
            return list.count > 10 ? Array(list.prefix(10)): list
        }
        
        func distanceFromPoint(place1:Place , place2 : Place) -> Double{
            var aLoc : CLLocation
            if place1.googleStatus == 1 {
                aLoc = CLLocation(latitude: place1.googleLocationLat, longitude: place1.googleLocationLong)
            }else{
                aLoc = CLLocation(latitude: place1.coordinatesLat, longitude: place1.coordinatesLong)
            }
            var bLoc : CLLocation
            if place2.googleStatus == 1 {
                bLoc = CLLocation(latitude: place2.googleLocationLat, longitude: place2.googleLocationLong)
            }else{
                bLoc = CLLocation(latitude: place2.coordinatesLat, longitude: place2.coordinatesLong)
            }
            return aLoc.distance(from: bLoc)
        }
        
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
//            print("to location")
            
            self.parent.animate(toLocation: CLLocationCoordinate2D(latitude: location.coordinate.latitude , longitude: location.coordinate.longitude))
//            NotificationCenter.default.post(name: .updateLocation,object: location )
            Utility.currentLocation = location
        }
            
        

        
    }
}

