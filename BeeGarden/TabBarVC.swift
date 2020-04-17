//
//  TabBarVC.swift
//  BeeGarden
//
//  Created by steven liu on 18/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    let itemImages = [ "icons8-home-100","icons8-sprout-100","icons8-camera-100","icons8-museum-100" ]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageNameForSelectedState   = itemImages[i]
                let imageNameForUnselectedState = itemImages[i]

                self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState)?.withRenderingMode(.automatic)
                self.tabBar.items?[i].imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }

        let selectedColor   = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let unselectedColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12) ], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15) ], for: .selected)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 3.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
         let firstTime = UserDefaults.standard.object(forKey: "isFirstTime") as? Bool // Here you look if the Bool value exists, if not it means that is the first time the app is opened

         // Show the intro collectionView
         if firstTime == nil {
             let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tutorialPage") // Instatiates your pageView
             present(view, animated: false)
             UserDefaults.standard.set(false, forKey: "isFirstTime")
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
