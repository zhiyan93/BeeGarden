//
//  HomeKnowDetailVC.swift
//  BeeGarden
//
//  Created by steven liu on 10/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit

class HomeKnowDetailVC: UIViewController {
    
    
   
    @IBOutlet weak var nameText: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
  
    @IBOutlet weak var descText: UITextView!
    
    
    var selectedKnow : KnowledgeEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
             // databaseController?.addListener(listener: self)
             
              changeValue()
       } 
    
    func changeValue()  {
        //let homeScreen = storyboard?.instantiateViewController(withIdentifier: "homeScreen") as! HomeViewController
      //  homeScreen.sightSelectDelegate = self
        if selectedKnow != nil {
            let tapedKnow = selectedKnow!
         //    bar.title = tapedSight.name
            
            nameText.text = tapedKnow.name
            descText.text = tapedKnow.desc
            imageView.image = UIImage(data: tapedKnow.image! as Data)
            
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
