//
//  HomeBeeDetailVC.swift
//  BeeGarden
//
//  Created by steven liu on 10/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit

class HomeBeeDetailVC: UIViewController {
   
    
    @IBOutlet weak var beeName: UILabel!
    @IBOutlet weak var beeImage: UIImageView!
    
    @IBOutlet weak var beeDesc: UITextView!
    
     var selectedBee : BeeEntity?
     //weak var databaseController : DatabaseProtocol?  //coredata
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//           databaseController = appDelegate.databaseController   //coredata
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
          // databaseController?.addListener(listener: self)
          
           changeValue()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func changeValue()  {
           //let homeScreen = storyboard?.instantiateViewController(withIdentifier: "homeScreen") as! HomeViewController
         //  homeScreen.sightSelectDelegate = self
           if selectedBee != nil {
               let tapedBee = selectedBee!
            //    bar.title = tapedSight.name
               
               beeName.text = tapedBee.name
               beeDesc.text = tapedBee.desc
               beeImage.image = UIImage(data: tapedBee.image! as Data)
               
           }
       }
       

}
