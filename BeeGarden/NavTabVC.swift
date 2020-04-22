//
//  NavTabVC.swift
//  BeeGarden
//
//  Created by steven liu on 21/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import Lottie

class NavTabVC: UIViewController,DatabaseListener  {
    func onGardenChange(change: DatabaseChange, gardenPlants: [FlowerEntity]) {
        flowers = gardenPlants
    }
    
    var listenerType = ListenerType.all

    
    func onObserveListChange(change: DatabaseChange, observesDB: [ObserveEntity]) {
        observes = observesDB
    }
    
    func onBeeListChange(change: DatabaseChange, beesDB: [BeeEntity]) {
        
    }
    
    func onKnowledgeListChange(change: DatabaseChange, knowsDB: [KnowledgeEntity]) {
        
    }
    
    func onSpotListChange(change: DatabaseChange, spotsDB: [SpotEntity]) {
        spots = spotsDB
    }
    
    func onFlowerListChange(change: DatabaseChange, flowersDB: [FlowerEntity]) {
        //flowers = flowersDB
    }
    
    func onRecordListChange(change: DatabaseChange, recordsDB: [PlantRecordEntity]) {
        
    }
    weak var databaseController : DatabaseProtocol?

    var flowers = [FlowerEntity]()
    var observes = [ObserveEntity]()
   var spots = [SpotEntity]()
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var daysTV: UITextField!
    
    
    @IBOutlet weak var plantAniView: UIView!
    @IBOutlet weak var PlantCount: UITextField!
    @IBOutlet weak var plantBtn: UIButton!
    
    @IBOutlet weak var observeAniView: UIView!
    @IBOutlet weak var observeCount: UITextField!
    @IBOutlet weak var observeBtn: UIButton!
    
    @IBOutlet weak var spotAniView: UIView!
    @IBOutlet weak var spotCount: UITextField!
    @IBOutlet weak var nearbyBtn: UIButton!
    
    
    @IBOutlet weak var plantSection: UIView!
    @IBOutlet weak var observeSection: UIView!
    @IBOutlet weak var nearbySection: UIView!
    
    var plantAni : AnimationView?
    var observeAni : AnimationView?
    var spotAni : AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController   //coredata
         
        avatarView.makeRounded()
        avatarView.image = UIImage(named: "user")
        
        plantAni = AnimationView(name: "gardening")
        setAnimation(logoAnimation: plantAni!, size: plantAniView.bounds.width, view: plantAniView)
        
        observeAni = AnimationView(name:"travel-camera")
        setAnimation(logoAnimation: observeAni!, size: observeAniView.bounds.width, view: observeAniView)
        
        spotAni = AnimationView(name:"travelers")
        setAnimation(logoAnimation: spotAni!, size: spotAniView.bounds.width - 40, view: spotAniView)
        
        
        plantSection.layer.cornerRadius = 15
        observeSection.layer.cornerRadius = 15
        nearbySection.layer.cornerRadius = 15
        
        plantBtn.layer.cornerRadius = 10
        observeBtn.layer.cornerRadius = 10
        nearbyBtn.layer.cornerRadius = 10
        
        let btnImage = UIImage(named: "chevron128p")
      //  let btnSelectImage = UIImage(named: "chevronb128p")
        
        plantBtn.setImage(btnImage, for: .normal)
        observeBtn.setImage(btnImage, for: .normal)
        nearbyBtn.setImage(btnImage, for: .normal)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
           databaseController?.addListener(listener: self)
        
         PlantCount.text = String(flowers.count)
        observeCount.text = String(observes.count)
        spotCount.text = String(spots.count)
        
        plantAni?.play()
        observeAni?.play()
        spotAni?.play()
        
        setDaysDiff()
           
       }
    
    
    override func viewWillDisappear(_ animated: Bool) {
              super.viewWillDisappear(animated)
              databaseController?.removeListener(listener: self)
        
       
          }
    
    override func viewDidAppear(_ animated: Bool) {
     
    }
    
    @IBAction func addPlantBtn(_ sender: Any) {
        let tabBar = storyboard?.instantiateViewController(withIdentifier: "tabBar") as! TabBarVC
        tabBar.selectedIndex = 1
            present(tabBar, animated: true, completion: nil)
    }
    
    @IBAction func addObserveBtn(_ sender: Any) {
        let tabBar = storyboard?.instantiateViewController(withIdentifier: "tabBar") as! TabBarVC
               tabBar.selectedIndex = 2
                   present(tabBar, animated: true, completion: nil)
    }
    
    @IBAction func showSpotsBtn(_ sender: Any) {
        let tabBar = storyboard?.instantiateViewController(withIdentifier: "tabBar") as! TabBarVC
               tabBar.selectedIndex = 3
                   present(tabBar, animated: true, completion: nil)
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
    
    private func setDaysDiff(){
        let sday = UserDefaults.standard.object(forKey: "startDay") as? Date // Here you look if the Bool value exists, if not it means that is the first time the app is opened

        // Show the intro collectionView
        if sday == nil {
            UserDefaults.standard.set(Date(), forKey: "startDay")
            self.daysTV.text = "0"
        }
        else{
            let daysDiff = Calendar.current.dateComponents([.day], from: sday ?? Date(), to: Date()).day!
            print(daysDiff)
            self.daysTV.text = String(daysDiff)
           self.daysTV.reloadInputViews()
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

extension UIImageView {

    func makeRounded() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
