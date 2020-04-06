//
//  AddObserveVC.swift
//  BeeGarden
//
//  Created by steven liu on 5/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import MapKit

protocol AddObserveDelegate : AnyObject {
    func addObserve(newObserve : Observe) -> Bool
}


class AddObserveVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,UITextViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var observeName: UITextField!
    
    @IBOutlet weak var observeDesc: UITextView!
    
    @IBOutlet weak var currentLoc: UITextView!
    @IBOutlet weak var observeLat: UITextField!
    
    @IBOutlet weak var observeLon: UITextField!
    
    @IBOutlet weak var observeTime: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var observeWeather: UITextView!
    
    
    weak var databaseController: DatabaseProtocol?
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var locationFormAdd : CLLocationCoordinate2D?  //
    var imageHasSet: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Get the database controller once from the App Delegate
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             databaseController = appDelegate.databaseController
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
               locationManager.distanceFilter = 10
               locationManager.delegate = self
               locationManager.requestAlwaysAuthorization()
        
        observeName.delegate = self
        observeDesc.delegate = self
        observeWeather.delegate = self
        currentLoc.text = "Melbourne"
        imageHasSet = false
    }
    
    @IBAction func imageClicked(_ sender: Any) {
        
        let imagePicker: UIImagePickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .savedPhotosAlbum
        }
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func getLocationBtn(_ sender: Any) {
         setLocationFields()
    }
    
    @IBAction func createBtn(_ sender: Any) {
       
        
        if self.imageView.image == nil || self.imageHasSet == false  {
                   displayMessage(title: "invalid image!", message: "please take a photo first")
                   return
               }
               
        if observeName.text != "" && observeDesc.text != "" && observeTime.text != "" && observeWeather.text != ""{
                   let name = observeName.text!
                   let desc = observeDesc.text!
                   let image = imageView.image!
            let weather = observeWeather.text!
            let time = observeTime.text!
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = df.date(from: time)
                  // let lat = sightLat
                 //  let lon = sightLon
            let lat = currentLocation?.latitude //lantitude!
            let lon  = currentLocation?.longitude
                 
                  // let sight = Sight(image: image, name: name, desc: desc, lat: lat, lon: lon,icon: icon)
                 //  let _ = addSightDelegate!.addSight(newSight: sight)
            let _ = databaseController!.addObserve(name: name, desc: desc, image: image, lat: lat!, lon: lon!, weather: weather, time: date!)
            //TODO
            
           
                   navigationController?.popViewController(animated: true)
                   return
               }
               var errorMsg = "Please ensure all fields are filled:\n"
               if observeName.text == "" {
                   errorMsg += "- Must provide a name\n"
               }
               if observeDesc.text == "" {
                   errorMsg += "- Must provide description"
               }
               displayMessage(title: "Not all fields filled", message: errorMsg)
        
    }
    
    private func setLocationFields()
    {
        if let currentLocation = currentLocation {
             let lat = "\(currentLocation.latitude)"
            let lon =  "\(currentLocation.longitude)"
            observeLat.text = lat
              
            observeLon.text = lon
              
            getAddressFromLatLon(pdblLatitude: lat, withLongitude: lon)
        }
        else {
            let alertController = UIAlertController(title: "Location Not Found", message: "The location has not yet been determined.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
      {
          let location = locations.last!
          currentLocation = location.coordinate
      }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          locationManager.startUpdatingLocation()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
       let now =  df.string(from: Date())
        self.observeTime.text = now
        self.observeWeather.text = "sunny"
        self.observeDesc.text = "description"
       
        
      }
    
      override func viewDidDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          locationManager.stopUpdatingLocation()
      }
      
      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          self.view.endEditing(true)
          return true
      }
      
      func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
          if(text == "\n") {
              textView.resignFirstResponder()
              return false
          }
          return true
      }
      
      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
      }
    
    // https://stackoverflow.com/questions/41358423/swift-generate-an-address-format-from-reverse-geocoding
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        
        let lon: Double = Double("\(pdblLongitude)")!
        
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
                    self.currentLoc.text = addressString
                }
        })
        
    }
    
    
    
    func displayMessage(title: String, message: String) {
        // Setup an alert to show user details about the Person
        // UIAlertController manages an alert instance
        let alertController = UIAlertController(title: title, message: message, preferredStyle:
            UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler:
            nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imageView.image = pickedImage
        imageHasSet = true
    }
    

}
