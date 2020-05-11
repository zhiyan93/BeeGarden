//
//  InaturalistActVC.swift
//  BeeGarden
//
//  Created by steven liu on 12/5/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices


class InaturalistActVC: UIViewController, SFSafariViewControllerDelegate {

    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    let site = "https://www.inaturalist.org/oauth/token"
    let userDetailUrl = "https://www.inaturalist.org/users/edit.json"
       let app_id = "9281c3348ede35fe42cd237d17d5671dc16fa5b969acec35a53ef93bc156102b"
       let app_secret = "d82366d07c154c8eacefec96bb47dab704f20195c75e0a9bd41bbb3d48358bca"
       let redirect_uri = "BeeMate://post"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImage.makeRounded()
        loginBtn.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
          let avatarImage = UserDefaults.standard.object(forKey: "NatAccountAvatar") as? Data
        if avatarImage != nil {
            profileImage.image = UIImage(data: avatarImage!)
        }
        else {
            profileImage.image = UIImage(named: "account128p")
        }
        
    }
    
    
    @IBAction func loginBtnAct(_ sender: Any) {
        
        if userName.text == ""  {
            return
        }
        if password.text == "" {
            
            return
        }
        
        let payload: [String: String] = [
                  "client_id" : app_id,
                  "client_secret" : app_secret,
                  "grant_type" : "password",
                  "username" : self.userName.text ?? "",
                  "password" : self.password.text ?? ""
                  
              ]

             AF.request(site, method:.post, parameters: payload,encoding: JSONEncoding.default) .responseJSON { (response) in
              print("request: ",response.request)  // original URL request
              //print("response",response.response) // URL response
              print("data: ",response.data)     // server data
              print("result: ",response.result)   // result of response serialization
                  print("response: ",response)
                switch response.result {
                case .success : if let json = response.value as? [String: Any] {
                     TopNotesPush.push(message: "\(self.userName.text!) successfully login", color: .color(color: Color.LightBlue.a700))
                    let accessToken : String = json["access_token"] as! String
                    print(accessToken)
                    UserDefaults.standard.set("Bearer "+accessToken, forKey: "iNaturalistACTK")
                    let headers: HTTPHeaders = ["Authorization": "Bearer "+accessToken]
                    
                    AF.request(self.userDetailUrl, method: .get, headers: headers).responseJSON { (response) in
                        switch response.result {
                        case .success : if let json = response.value as? [String: Any] {
                            if let userImageUrl: String = json["medium_user_icon_url"] as? String {
                                
                                self.NKPlaceholderImage(image: UIImage(named: "account128p"), imageView: self.profileImage, imgUrl: userImageUrl) { (image) in
                                    
                                    UserDefaults.standard.set(image?.jpegData(compressionQuality: 0.8), forKey: "NatAccountAvatar" )
                                }
                                                       }
                            
                            
                        }
                           
                            
                        case .failure(_):
                            return
                        }
                        
                    }
                    
                   // self.dismiss(animated: true, completion: nil)
                    }
                
                case .failure(_):  TopNotesPush.push(message: "incorrect user name or password", color: .color(color: Color.LightPink.first))
                    
                    
                    
                }
              }
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
    
    @IBAction func signupBtnAct(_ sender: Any) {
        let urlString = "https://www.inaturalist.org/signup"

        if let url = URL(string: urlString) {
                   let vc = SFSafariViewController(url: url)
                   vc.delegate = self

                   present(vc, animated: true)
               }
        
    }
    
    func NKPlaceholderImage(image:UIImage?, imageView:UIImageView?,imgUrl:String,compate:@escaping (UIImage?) -> Void){

    if image != nil && imageView != nil {
        imageView!.image = image!
    }

    var urlcatch = imgUrl.replacingOccurrences(of: "/", with: "#")
    let documentpath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    urlcatch = documentpath + "/" + "\(urlcatch)"

    let image = UIImage(contentsOfFile:urlcatch)
    if image != nil && imageView != nil
    {
        imageView!.image = image!
        compate(image)

    }else{

        if let url = URL(string: imgUrl){

            DispatchQueue.global(qos: .background).async {
                () -> Void in
                let imgdata = NSData(contentsOf: url)
                DispatchQueue.main.async {
                    () -> Void in
                    imgdata?.write(toFile: urlcatch, atomically: true)
                    let image = UIImage(contentsOfFile:urlcatch)
                    compate(image)
                    if image != nil  {
                        if imageView != nil  {
                            imageView!.image = image!
                        }
                    }
                }
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

}


}


