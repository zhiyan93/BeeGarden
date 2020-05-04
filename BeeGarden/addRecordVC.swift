//
//  addRecordVC.swift
//  BeeGarden
//
//  Created by steven liu on 26/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit

class addRecordVC: UIViewController {
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    @IBAction func panGesture(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    //    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        dismiss(animated: true, completion: nil)
//    }
    }






    
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//

