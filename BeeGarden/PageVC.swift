//
//  PageVC.swift
//  BeeGarden
//
//  Created by steven liu on 18/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

//import UIKit
//
//
//
//class PageVC: UIViewController {
//
//   var titleLabel: UILabel?
//     var imageView : UIImageView?
//     var page: Pages
//     let screenSize: CGRect = UIScreen.main.bounds
//
//
//     init(with page: Pages) {
//         self.page = page
//
//         super.init(nibName: nil, bundle: nil)
//     }
//
//     required init?(coder: NSCoder) {
//         fatalError("init(coder:) has not been implemented")
//     }
//
//     override func viewDidLoad() {
//         super.viewDidLoad()
//
//         titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
//         titleLabel?.center = CGPoint(x: 160, y: 250)
//         titleLabel?.textAlignment = NSTextAlignment.center
//         titleLabel?.text = page.name
//
//         imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenSize.width,height: screenSize.height))
//         imageView?.contentMode = .scaleAspectFit
//         imageView!.image = UIImage(named: "vaa")
//
//       let button:UIButton = UIButton(frame: CGRect(x: 100, y: 400, width: 300, height: 50))
//        let verticalCenter: CGFloat = UIScreen.main.bounds.midY + 200
//        let horizontalCenter: CGFloat = UIScreen.main.bounds.midX
//       button.center = CGPoint(x: horizontalCenter, y: verticalCenter)
//       button.backgroundColor = .black
//       button.setTitle("Begin my BeeMate career", for: .normal)
//       button.addTarget(self, action:#selector(self.buttonClicked), for:   .touchUpInside)
//        if(self.page == Pages.pageThree){
//            button.isEnabled = true
//            button.isHidden = false
//        }
//        else {
//            button.isEnabled = false
//            button.isHidden = true
//        }
//
//
//         self.view.addSubview(titleLabel!)
//         //self.view.addSubview(imageView!)
//         self.view.addSubview(button)
//
//     }
//
//     @objc func buttonClicked() {
//         print("Button Clicked")
//         dismiss(animated: true, completion: nil)
//     }
//
//}
