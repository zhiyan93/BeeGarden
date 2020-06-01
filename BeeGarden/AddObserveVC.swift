//
//  AddObserveVC.swift
//  BeeGarden
//
//  Created by steven liu on 5/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import MapKit
import SwiftEntryKit
import Accelerate
import Lottie
import SwiftyJSON
import NVActivityIndicatorView
import CoreML
import Vision
import ImageIO
import CropViewController

protocol AddObserveDelegate : AnyObject {
    func addObserve(newObserve : Observe) -> Bool
}


class AddObserveVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,UITextViewDelegate,CLLocationManagerDelegate, CropViewControllerDelegate  {
    
    @IBOutlet weak var observeName: UITextField!
    
    @IBOutlet weak var observeDesc: UITextView!
    
    @IBOutlet weak var currentLoc: UITextView!
   
    @IBOutlet weak var observeTime: UILabel!
    
    
    @IBOutlet weak var useLocBtn: UIButton!
    
    @IBOutlet weak var createBtn: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var observeWeather: UITextView!
    
    @IBOutlet weak var tapAniView: UIView!
    
    @IBOutlet weak var weatherBtn: UIButton!
    
    
    @IBOutlet weak var classResLab: UILabel!
    
    @IBOutlet weak var classResView: UIView!
    
    @IBOutlet weak var classResVE: UIVisualEffectView!
    
    
    @IBOutlet weak var cautionLab: UILabel!
    
    weak var databaseController: DatabaseProtocol?
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -37.813407, longitude: 144.969730)
    var locationFormAdd : CLLocationCoordinate2D?  //
    var imageHasSet: Bool = false
    var activityIndicator: NVActivityIndicatorView!
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            let model = try VNCoreMLModel(for: MobileNet().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
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
        useLocBtn.layer.cornerRadius = 10
        createBtn.layer.cornerRadius = 10
        weatherBtn.layer.cornerRadius = 10
       let tapAni = AnimationView(name: "hand-tap")
    
        LotAnimation.setAnimation(logoAnimation: tapAni, size: 80, view: tapAniView)
        tapAni.play()
        
       setIndicator()
        self.classResVE.isHidden = true
       
         
       // let borderGray = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        self.observeDesc.layer.borderColor = UIColor.label.withAlphaComponent(0.6).cgColor
        self.observeDesc.layer.borderWidth = 0.5
        self.observeDesc.layer.cornerRadius = 5
        self.observeWeather.text = " Weather: \n Tempetature: \n Pressure: \n Humidity: %\n Clouds: %\n  Wind speed: \n Wind direction:  \n"
               self.observeDesc.text = " "
    }
    
    @IBAction func imageClicked(_ sender: Any) {
        
        
    }
    
    
    @IBAction func cameraBtnAct(_ sender: Any) {
        
        tapAniView.isHidden = true
      //  let imagePicker: UIImagePickerController = UIImagePickerController()
        
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            imagePicker.sourceType = .camera
//        } else {
//            imagePicker.sourceType = .savedPhotosAlbum
//        }
        // Show options for the source picker only if the camera is available.
               guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                   presentPhotoPicker(sourceType: .photoLibrary)
                   return
               }
               
               let photoSourcePicker = UIAlertController()
               let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
                   self.presentPhotoPicker(sourceType: .camera)
               }
               let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
                   self.presentPhotoPicker(sourceType: .photoLibrary)
               }
               
               photoSourcePicker.addAction(takePhoto)
               photoSourcePicker.addAction(choosePhoto)
               photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
               
               present(photoSourcePicker, animated: true)
        
        
        
      //  imagePicker.allowsEditing = true
     //   imagePicker.delegate = self
    //    present(imagePicker, animated: true, completion: nil)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
           let picker = UIImagePickerController()
           picker.delegate = self
       // picker.allowsEditing = true
           picker.sourceType = sourceType
           present(picker, animated: true)
       }
    
//    func presentCropViewController(image: UIImage) {
//         //let image: UIImage = #imageLiteral(resourceName: "lavender") //Load an image
//
//         let cropViewController = CropViewController(image: image)
//         cropViewController.delegate = self
//         present(cropViewController, animated: true, completion: nil)
//       }

      
    
    func updateClassifications(for image: UIImage) {
        classResLab.text = "Classifying..."
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// Updates the UI with the results of the classification.
      /// - Tag: ProcessClassifications
      func processClassifications(for request: VNRequest, error: Error?) {
          DispatchQueue.main.async {
              guard let results = request.results else {
                  self.classResLab.text = "Unable to classify image.\n\(error!.localizedDescription)"
                  return
              }
              // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
              let classifications = results as! [VNClassificationObservation]
          
              if classifications.isEmpty {
                  self.classResLab.text = "Nothing recognized."
              } else {
                  // Display top classifications ranked by confidence in the UI.
                  let topClassifications = classifications.prefix(2)
                  let descriptions = topClassifications.map { classification in
                      // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                     return String(format: " detected: %@; confidence: %.2f", classification.identifier,classification.confidence )
                  }
                  self.classResLab.text = "Classification:\n" + descriptions.joined(separator: "\n")
                
                self.cautionLab.isHidden = true
              }
          }
      }
    
    
    
    
    @IBAction func weatherBtnAct(_ sender: Any) {
        let lan = currentLocation.latitude
        let lon = currentLocation.longitude
        activityIndicator.startAnimating()
      let request =  WeatherAPI.requestWeather(latitude: lan, longitude: lon)
        request.responseJSON {
        (data) in
            let jsonResponse = JSON(data.value ?? "{}")
          let res =  WeatherAPI.fetchDataFromRequest(jsonResponse: jsonResponse)
            print(res)
            self.activityIndicator.stopAnimating()
            self.observeWeather.text = res
    }
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
            
            let smallSize = CGSize(width: image.size.width/1.5,height: image.size.height/1.5)
            let smallImage = image.resizeImageUsingVImage(size:smallSize)!
            
            let weather = observeWeather.text!
            let time = observeTime.text!
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd , HH:mm:ss"
            let date = df.date(from: time)
                  // let lat = sightLat
                 //  let lon = sightLon
            let lat = currentLocation.latitude //lantitude!
            let lon  = currentLocation.longitude
                 
                  // let sight = Sight(image: image, name: name, desc: desc, lat: lat, lon: lon,icon: icon)
                 //  let _ = addSightDelegate!.addSight(newSight: sight)
            let _ = databaseController!.addObserve(name: name, desc: desc, image: smallImage, lat: lat , lon: lon , weather: weather, time: date ?? Date())
            //TODO
            TopNotesPush.push(message: "obsrvation created successfully", color: .color(color: Color.LightBlue.a700))
           
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
       
             let lat = "\(currentLocation.latitude)"
            let lon =  "\(currentLocation.longitude)"
           // observeLat.text = lat
              
           // observeLon.text = lon
              
            getAddressFromLatLon(pdblLatitude: lat, withLongitude: lon)
        
//        else {
//            let alertController = UIAlertController(title: "Location Not Found", message: "The location has not yet been determined.", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//            present(alertController, animated: true, completion: nil)
//        }
    }
    
    private func setIndicator(){
        let indicatorSize: CGFloat = 120
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (observeWeather.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: .systemOrange, padding: 5.0)
        activityIndicator.backgroundColor = .clear
        
        //print(view.frame.height)
        self.observeWeather.addSubview(activityIndicator)
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
        df.dateFormat = "yyyy-MM-dd , HH:mm:ss"
       let now =  df.string(from: Date())
        self.observeTime.text = now
       
       
       
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
      //  self.classResVE.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //dismiss(animated: true, completion: nil)
        
        guard let pickedImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else {return}
        let cropController = CropViewController(image: pickedImage)
        cropController.delegate = self
        
    picker.dismiss(animated: false, completion: {
                     self.present(cropController, animated: true, completion: nil)
       // cropController.hidesBottomBarWhenPushed = true
               //      self.navigationController!.pushViewController(cropController, animated: true)
      //  self.tabBarController?.hidesBottomBarWhenPushed = true
                 })
       // imageView.image = pickedImage
        
//        self.classResVE.isHidden = false
//      //  self.classResView.isHidden = false
//
//        updateClassifications(for: pickedImage)
//        imageHasSet = true
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
                  // 'image' is the newly cropped version of the original image
              self.imageView.image = image
        
        self.classResVE.isHidden = false
        updateClassifications(for: image)
        imageHasSet = true
        
              dismiss(animated: true, completion: nil)
              }
    
   
    
    // MARK: - Handling Image Picker Selection

//      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//         picker.dismiss(animated: true)
//
//         // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
//
//         let image = info[.originalImage] as! UIImage
//         imageView.image = image
//         updateClassifications(for: image)
//    }
    

}

extension UIImage{
    func resizeImageUsingVImage(size:CGSize) -> UIImage? {
         let cgImage = self.cgImage!
         var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue), version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
         var sourceBuffer = vImage_Buffer()
         defer {
              free(sourceBuffer.data)
         }
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
         guard error == kvImageNoError else { return nil }
       // create a destination buffer
       let scale = self.scale
       let destWidth = Int(size.width)
       let destHeight = Int(size.height)
       let bytesPerPixel = self.cgImage!.bitsPerPixel/8
       let destBytesPerRow = destWidth * bytesPerPixel
       let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
       defer {
        destData.deallocate( )  //
       }
      var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
    // scale the image
     error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
     guard error == kvImageNoError else { return nil }
     // create a CGImage from vImage_Buffer
     var destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
    guard error == kvImageNoError else { return nil }
    // create a UIImage
     let resizedImage = destCGImage.flatMap { UIImage(cgImage: $0, scale: 0.0, orientation: self.imageOrientation) }
     destCGImage = nil
    return resizedImage
    }
}


