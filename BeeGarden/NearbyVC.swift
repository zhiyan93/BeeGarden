//
//  NearbyVC.swift
//  BeeGarden
//
//  Created by steven liu on 11/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class NearbyVC: UIViewController ,DatabaseListener  {
    func onGardenChange(change: DatabaseChange, gardenPlants: [FlowerEntity]) {
        
    }
    
    func onFlowerListChange(change: DatabaseChange, flowersDB: [FlowerEntity]) {
        
    }
    
    func onRecordListChange(change: DatabaseChange, recordsDB: [PlantRecordEntity]) {
        
    }
    
    var listenerType = ListenerType.spot
     var spots : [SpotEntity] = []
    var spotsName :[String] = []
     var selectedSpot : SpotEntity?
    
    @IBOutlet weak var segmentCtl: UISegmentedControl!
    weak var databaseController : DatabaseProtocol?
    
    func onObserveListChange(change: DatabaseChange, observesDB: [ObserveEntity]) {
        
    }
    
    func onBeeListChange(change: DatabaseChange, beesDB: [BeeEntity]) {
        
    }
    
    func onKnowledgeListChange(change: DatabaseChange, knowsDB: [KnowledgeEntity]) {
        
    }
    
    func onSpotListChange(change: DatabaseChange, spotsDB: [SpotEntity]) {
        spots = spotsDB
       
        for s in spots{
            spotsName.append(s.name ?? "defalut name")
        }
    }
    

    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    private var currentLocation :CLLocation?
    let regionRadius: Double = 6000
    var isFirstZoomedToUserLocation: Bool = true
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
               databaseController = appDelegate.databaseController   //coredata
        
        mapView.delegate = self
        configureLocationServices()
    }
    
    @IBAction func segmentAct(_ sender: UISegmentedControl) {
        switch self.segmentCtl.selectedSegmentIndex {
        case 0: print("segment 0")
        case 1: print("segment 1")
        case 2: print("segment 2")
        case 3: print("segment 3")
        case 4: print("segment 4")
        default:
            print("segment default")
        }
        self.mapView.removeAnnotations(mapView.annotations)
        for s in spots{
                   addSpotAnnotation(spot: s)
               }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        
        for s in spots{
            addSpotAnnotation(spot: s)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           databaseController?.removeListener(listener: self)
       }
    
    private func filterAnnotations(category: Int){
        
    }
    private func configureLocationServices() {
           locationManager.delegate = self
           let status = CLLocationManager.authorizationStatus()
           if  status == .notDetermined {
               locationManager.requestAlwaysAuthorization()
           } else if status == .authorizedAlways || status == .authorizedWhenInUse {
               beginLocationUpdates(locationManager: locationManager)
           }
       }
    
    private func beginLocationUpdates(locationManager : CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
  private func centerMapOnUserLocation() {
       guard let coordinate = locationManager.location?.coordinate else {return}
       let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
       mapView.setRegion(coordinateRegion, animated: true)
   }
    
  private func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
                    -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
                
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                 // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
      private func addSpotAnnotation(spot: SpotEntity) {
            let myAnnotation = MKPointAnnotation()
            myAnnotation.title = spot.name
          //  myAnnotation.subtitle = sight.desc
       let lat = spot.latitude
        let lon = spot.longitude
    myAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
              //  setGeofencing(lat: lat, lon: lon, radius: 500, identifier: sight.name!, set: true)   //geofencing
             
            
            mapView.addAnnotation(myAnnotation)
    //        if let latitude = Double(myAnnotation.latitude!), let longitude = Double(myAnnotation.longitude!), let identifier = myAnnotation.name {
    //            setGeofencing(lat: latitude, lon: longitude, radius: 500, identifier: identifier, set: true)
    //        }
        
        }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = annotation.title
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: (identifier ?? "defalut")!)

        let spotOrder = spotsName.firstIndex(of:annotation.title!!) ?? 0
        
        var iconName: String = ""
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier!)
            switch spots[spotOrder].category {
            case 1 : iconName = "teamwork128p"
            case 2 : iconName = "museum128p"
            case 3 : iconName = "hive128p"
            case 4 : iconName = "plants128p"
            default:
                iconName = "teamwork128p"
            }
            annotationView?.image = UIImage(named: iconName)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        annotationView!.isHidden = true
        if self.segmentCtl.selectedSegmentIndex == 0 {
            annotationView?.isHidden = false
        }
        if self.segmentCtl.selectedSegmentIndex == 1, spots[spotOrder].category == 1{
            annotationView?.isHidden = false
        }
        if self.segmentCtl.selectedSegmentIndex == 2, spots[spotOrder].category == 2{
            annotationView?.isHidden = false
        }
        if self.segmentCtl.selectedSegmentIndex == 3, spots[spotOrder].category == 3{
                   annotationView?.isHidden = false
               }
        if self.segmentCtl.selectedSegmentIndex == 4, spots[spotOrder].category == 4{
                annotationView?.isHidden = false
                      }
     
        configureRightView(annotationView: annotationView!,tagNum: spotOrder )
        configureDetailView(annotationView: annotationView!, image: UIImage(data: spots[spotOrder].image! as Data)!)
        

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            let buttonNum = control.tag
    //        let detailScreen = storyboard?.instantiateViewController(withIdentifier: "Sight Detail") as! DetailViewController
    //        present(detailScreen, animated: true, completion: nil)
            selectedSpot = spots[buttonNum]
         //   print(selectedSight!.name)
    //        self.sightSelectDelegate = DetailViewController()
           if selectedSpot != nil {
    //            sightSelectDelegate?.didSightSelect(selectedSight!)
             //dismiss(animated: true, completion: nil)
            let detailScreen = storyboard?.instantiateViewController(withIdentifier: "spotDetail") as! SpotDetailVC 
            detailScreen.selectedSpot =  selectedSpot!
                present(detailScreen, animated: true, completion: nil)
        //  dismiss(animated: true, completion: nil)
    //    }
            }
        }
    
   private func configureRightView(annotationView: MKAnnotationView, tagNum : Int){
        let rightButton = UIButton(type: .detailDisclosure)
        rightButton.tag = tagNum
        annotationView.rightCalloutAccessoryView = rightButton
    }
    
    private func configureDetailView(annotationView: MKAnnotationView, image : UIImage) {
            
            let detailView = UIImageView( image: image)
            
    //        let descView = UITextView.init()
    //        descView.text = "sfjsklfjdslfjdlsfkjdslfjdkls"
    //        detailView.addSubview(descView)
           
            let views = ["snapshotView": detailView]
            detailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[snapshotView(250)]", options: [], metrics: nil, views: views))
            detailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snapshotView(170)]", options: [], metrics: nil, views: views))
        
            annotationView.detailCalloutAccessoryView = detailView
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
extension NearbyVC: MKMapViewDelegate{
    
    
}

extension NearbyVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          
          guard let latestLocation = locations.first else { return}
        if isFirstZoomedToUserLocation == true {
            centerMapOnUserLocation()
            isFirstZoomedToUserLocation = false
            
        }
         
//
//          if currentCoordinate == nil {
//        zoomToLatestLocation(with: latestLocation.coordinate)
//          //    addAnnotations()
//          }
         
          currentCoordinate = latestLocation.coordinate
      }
      
      func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          if status == .authorizedAlways || status == .authorizedWhenInUse {
              beginLocationUpdates(locationManager: manager)
            centerMapOnUserLocation()
          }
      }
    
    
}
