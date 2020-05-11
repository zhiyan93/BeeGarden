//
//  ObserveDetailVC.swift
//  BeeGarden
//
//  Created by steven liu on 30/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import CoreLocation

class ObserveDetailVC: UIViewController, CLLocationManagerDelegate {

    
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var descTV: UITextView!
    
    @IBOutlet weak var locLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var weatherTV: UITextView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    
    @IBOutlet weak var accountBtn: UIButton!
    
    var selectObserve = ObserveEntity()
    
    var locationManager: CLLocationManager = CLLocationManager()
     
     
       
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        backBtn.layer.cornerRadius = 10
        accountBtn.layer.cornerRadius = 10
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeValue()
    }
    

    @IBAction func backBtnAct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func accountBtnAct(_ sender: Any) {
        
         let loginView = storyboard?.instantiateViewController(withIdentifier: "logInView") as! InaturalistActVC
        present(loginView,animated: true)
        print("login")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func changeValue() {
        name.text = selectObserve.name
        imageView.image = UIImage(data: selectObserve.image!)
        descTV.text = selectObserve.desc
        getAddressFromLatLon(pdblLatitude: selectObserve.latitude, withLongitude: selectObserve.longitude)
       let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeLabel.text = df.string(from: selectObserve.time ?? Date())
        weatherTV.text = selectObserve.weather
    }
    
 
    
    // https://stackoverflow.com/questions/41358423/swift-generate-an-address-format-from-reverse-geocoding
   private func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = pdblLatitude
        
        let lon: Double = pdblLongitude
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    
                    if pm.subThoroughfare != nil {
                        addressString = addressString + pm.subThoroughfare! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality!
                    }
                    // print(addressString)
                    self.locLabel.text = addressString
                }
        })
        
    }

}
