//
//  SpotDetailVC.swift
//  BeeGarden
//
//  Created by steven liu on 12/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import MapKit
import UIGradient

class SpotDetailVC: UIViewController,MKMapViewDelegate {
   
    

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var hours: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var contact: UILabel!
    
    @IBOutlet weak var website: UILabel!
    var selectedSpot : SpotEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
      
    }
    override func viewWillAppear(_ animated: Bool) {
        changeValue()
    }
    
   private func changeValue()  {
        //let homeScreen = storyboard?.instantiateViewController(withIdentifier: "homeScreen") as! HomeViewController
      //  homeScreen.sightSelectDelegate = self
        if selectedSpot != nil {
            let tapedSpot = selectedSpot!
         //    bar.title = tapedSight.name
            
            self.name.text = tapedSpot.name
            self.desc.text = tapedSpot.desc
            desc.isScrollEnabled = false
            self.hours.text = tapedSpot.openhour
            self.address.text = tapedSpot.place
            self.contact.text = tapedSpot.email
            self.website.text = tapedSpot.website
            imageView.image = UIImage(data: tapedSpot.image! as Data)
             addSpotAnnotation(spot: tapedSpot)
             let lat = tapedSpot.latitude
            let lon = tapedSpot.longitude
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
             zoomToLocation(with: coordinate)
        
    }
    }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                
                let identifier = "MyLocAnnotation"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MyLocAnnotation")
        //        if annotationView == nil {
        //            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
               
                if annotationView == nil {
                    annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                } else {
                    annotationView!.annotation = annotation
                }
                
                configureDetailView(annotationView: annotationView!)
                
                return annotationView
            }
    
       private func configureDetailView(annotationView: MKAnnotationView) {
        let width = 150
        let height = 100
        
        let snapshotView = UIView()
        let views = ["snapshotView": snapshotView]
        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[snapshotView(150)]", options: [], metrics: nil, views: views))
        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snapshotView(100)]", options: [], metrics: nil, views: views))
        
        let options = MKMapSnapshotter.Options()
        options.size = CGSize(width: width, height: height)
        options.mapType = .satelliteFlyover
        options.camera = MKMapCamera(lookingAtCenter: annotationView.annotation!.coordinate, fromDistance: 250, pitch: 65, heading: 0)
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            if snapshot != nil {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                imageView.image = snapshot!.image
                snapshotView.addSubview(imageView)
            }
        }
        
        annotationView.detailCalloutAccessoryView = snapshotView
    }
    
    
    
    private func zoomToLocation(with coordinate : CLLocationCoordinate2D) {
        
        let zoomRegion = MKCoordinateRegion(center: coordinate,latitudinalMeters: 500,longitudinalMeters: 500)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    
    private func addSpotAnnotation(spot: SpotEntity) {
           let myAnnotation = MKPointAnnotation()
           myAnnotation.title = spot.name
           //myAnnotation.subtitle = sight.desc
           let lat = spot.latitude
            let lon = spot.longitude
            myAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
           
           
           mapView.addAnnotation(myAnnotation)
       }
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


