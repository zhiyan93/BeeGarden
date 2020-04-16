//
//  HomeViewController.swift
//  BeeGarden
//
//  Created by steven liu on 11/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import Lottie

class HomeViewController: UIViewController {

    @IBOutlet weak var beeAnimation: UIView!
    @IBOutlet weak var bookAnimation: UIView!
    
    var bee : AnimationView?
    var book : AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
      bee = AnimationView(name: "bee-fiying")
     book = AnimationView(name: "book-animation")
        setAnimation(logoAnimation: bee!, size: 80, view: beeAnimation)
        setAnimation(logoAnimation: book!, size: 150,view: bookAnimation)
       

    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        bee?.play()
        book?.play()
    }
    
    func setAnimation(logoAnimation: AnimationView,size: CGFloat ,view: UIView){
        
           logoAnimation.contentMode = .scaleAspectFit
               logoAnimation.translatesAutoresizingMaskIntoConstraints = false
               logoAnimation.loopMode = LottieLoopMode.loop
               view.addSubview(logoAnimation)
               logoAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive  = true
               logoAnimation.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive  = true
               logoAnimation.heightAnchor.constraint(equalToConstant: size).isActive = true
               logoAnimation.widthAnchor.constraint(equalToConstant: size).isActive = true
               
               logoAnimation.play()
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
