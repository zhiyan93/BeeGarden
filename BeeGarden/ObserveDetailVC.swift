//
//  ObserveDetailVC.swift
//  BeeGarden
//
//  Created by steven liu on 30/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ObserveDetailVC: UIViewController, CLLocationManagerDelegate {

    
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var descTV: UITextView!
    
    @IBOutlet weak var locLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var weatherTV: UITextView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    
    @IBOutlet weak var accountBtn: UIButton!
    
    
    @IBOutlet weak var postBtn: UIButton!
    
    
    @IBOutlet weak var uploadProgress: UIProgressView!
    
    @IBOutlet weak var uploadIndicate: UIActivityIndicatorView!
    var selectObserve : ObserveEntity?
    
    var locationManager: CLLocationManager = CLLocationManager()
     
     
       
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        backBtn.layer.cornerRadius = 10
        accountBtn.layer.cornerRadius = 10
        postBtn.layer.cornerRadius = 10
       
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
    
    @IBAction func postBtnAct(_ sender: Any) {
           self.uploadIndicate.isHidden = false
        self.uploadIndicate.startAnimating()
        guard let accessToken : String = UserDefaults.standard.object(forKey: "iNaturalistACTK") as? String
            else {
                TopNotesPush.push(message: "Please login your iNaturalist account", color: .color(color: Color.LightPink.first))
                self.uploadIndicate.isHidden = true
            return }
        
     
        let headers = ["Authorization": accessToken,"Content-Type":"application/json"]
               let parameters: [String:Any] = [
                   "observation" : [
                    "species_guess": self.name.text ?? " ",
                       "taxon_id": 630955,
                       "description": self.descTV.text ?? " ",
                       "latitude" : self.selectObserve?.latitude ?? -37.813407,
                       "longitude" : self.selectObserve?.longitude ?? 144.969730,
                    "map_scale" : 10
                    
                   ] 
        ]
        
        AF.request("https://api.inaturalist.org/v1/observations", method : .post, parameters : parameters, encoding : JSONEncoding.default , headers : HTTPHeaders(headers)).responseJSON{ jsonResponse in

                  //print(jsonResponse.request as Any) // your request
                 // print(jsonResponse.response as Any) // your response
                 // print("data",dataResponse.data as Any)
                  print("result",jsonResponse.result as Any)
                 print("value",jsonResponse.value as Any)
            switch jsonResponse.result {
            case .success : if let json = jsonResponse.value as? [String: Any]  {
               let observationID = json["id"]
                let obUUID = json["uuid"]
                print("observationID:\(observationID); obUUID:\(obUUID)")
                 let obUrl =  "https://api.inaturalist.org/v1/observation_photos"
                let obImage = self.imageView.image?.jpegData(compressionQuality: 0.8)
                
                let headers: HTTPHeaders = [
                                  /* "Authorization": "your_access_token",  in case you need authorization header */
                                  "Authorization":accessToken,
                                  "Content-Type": "multipart/form-data"
                              ]
                   
                       let parameters: [String:Any] = [ "observation_photo[observation_id]" : observationID!, "observation_photo[uuid]":obUUID! ]
                self.postImage(url: obUrl, imageData: obImage, headers: headers , parameters : parameters)
                
                }
            case .failure(_):
                TopNotesPush.push(message: "fail to create observation!", color: .color(color: Color.LightPink.first))
            }
            
              }
        
    }
    
    func postImage (url: String,imageData: Data?, headers : HTTPHeaders ,parameters: Parameters) {
       


        AF.upload(multipartFormData: { (multipartFormData) in
           
            let obID : Int = parameters["observation_photo[observation_id]"] as! Int
            let obUUID : String = parameters["observation_photo[uuid]"] as! String
            multipartFormData.append("\(obID)".data(using: .utf8)!, withName: "observation_photo[observation_id]"  )
            multipartFormData.append(obUUID.data(using: .utf8)!, withName: "observation_photo[uuid]")
             if let data = imageData{
                multipartFormData.append(data, withName: "file", fileName: "lav.jpg", mimeType: "image/jpg")
            }

        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers)
            .uploadProgress {
                progrss in
                self.uploadProgress.isHidden = false
                print(progrss)
               let precent = progrss.fractionCompleted
                self.uploadProgress.progress = Float(precent)
        }
         .responseJSON { resp in
            print(resp.response)
            self.uploadProgress.isHidden = true
            self.uploadIndicate.isHidden = true
            switch resp.result {
            case .success :  TopNotesPush.push(message: "Upload successful on iNaturalist", color:  .color(color: Color.LightBlue.a700))
                
                
            case .failure(_):
                TopNotesPush.push(message: "fail to upload", color: .color(color: Color.LightPink.first))
            }
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
    
    private func changeValue() {
        name.text = selectObserve!.name
        imageView.image = UIImage(data: selectObserve!.image!)
        descTV.text = selectObserve!.desc
        getAddressFromLatLon(pdblLatitude: selectObserve?.latitude ?? -37.813407, withLongitude: selectObserve?.longitude ?? 144.969730)
       let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeLabel.text = df.string(from: selectObserve?.time ?? Date())
        weatherTV.text = selectObserve?.weather
        uploadProgress.isHidden = true
        uploadIndicate.isHidden = true
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
