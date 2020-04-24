//
//  PlantDetailVC.swift
//  BeeGarden
//
//  Created by steven liu on 25/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit

class PlantDetailVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descField: UITextView!
    
    @IBOutlet weak var climateSegment: UISegmentedControl!
    
    @IBOutlet weak var monthSegment: UISegmentedControl!
    
    @IBOutlet weak var nectarSegment: UISegmentedControl!
    
    @IBOutlet weak var pollenSegment: UISegmentedControl!
    
    
    @IBOutlet weak var recommandSegment: UISegmentedControl!
    
    @IBOutlet weak var plantBtn: UIButton!
    
    var selectedPlant: FlowerEntity?
    let climateColors :[UIColor] = [.systemOrange ,.systemOrange,.systemOrange,.systemOrange]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        changeValue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    
    @IBAction func plantBtnAct(_ sender: Any) {
    }
    
    private func changeValue(){
        self.nameLabel.text = selectedPlant?.name
        self.imageView.image = UIImage(data:  (selectedPlant?.image)!)
        self.descField.text = selectedPlant?.desc
        var climate = 0
        var climateColor = UIColor.green
        switch selectedPlant?.gclimate {
        case "Cool": climate = 0;  climateColor = climateColors[0]
        case "Temperate": climate = 1 ; climateColor = climateColors[1]
        case "Warm": climate = 2 ; climateColor = climateColors[2]
        case "Hot": climate = 3 ; climateColor = climateColors[3]
        default:
            climate = 0 ; climateColor = climateColors[0]
        }
        self.climateSegment.selectedSegmentIndex = climate
        self.climateSegment.selectedSegmentTintColor = climateColor
        
        let calendar = Calendar.current
       let currentMonth = calendar.component(.month, from: Date())
        print("currentm ",currentMonth)
    
        let months = selectedPlant?.gmonth!.split(separator: ",")
      
        for m in months! {
            print(m)
            guard let indexm = Int(m)  else {return}
                print("indexm ",indexm)
           
                let subViewOfSegment: UIView = monthSegment.subviews[indexm - 1] as UIView
                subViewOfSegment.backgroundColor = .systemOrange
            
          
            
        }
        
           self.monthSegment.selectedSegmentIndex = currentMonth - 1
              
           
        if selectedPlant?.nectar == "low"{
            self.nectarSegment.selectedSegmentIndex = 0
        }
        else {
            self.nectarSegment.selectedSegmentIndex = 1
        }
        nectarSegment.selectedSegmentTintColor = .systemOrange
        
        if selectedPlant?.pollen == "low"{
            self.pollenSegment.selectedSegmentIndex = 0
        }
        else{
            self.pollenSegment.selectedSegmentIndex = 1
        }
        pollenSegment.selectedSegmentTintColor = .systemOrange
        
        
        self.plantBtn.layer.cornerRadius = 10
       // self.plantBtn.backgroundColor = .systemOrange
        
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
