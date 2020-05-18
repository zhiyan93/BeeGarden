//
//  TutorialVC.swift
//  BeeGarden
//
//  Created by steven liu on 18/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit
import paper_onboarding

//enum Pages: CaseIterable {
//    case pageZero
//    case pageOne
//    case pageTwo
//    case pageThree
//
//    var name: String {
//        switch self {
//        case .pageZero:
//            return "This is page zero"
//        case .pageOne:
//            return "This is page one"
//        case .pageTwo:
//            return "This is page two"
//        case .pageThree:
//            return "This is page three"
//        }
//    }
//
//    var index: Int {
//        switch self {
//        case .pageZero:
//            return 0
//        case .pageOne:
//            return 1
//        case .pageTwo:
//            return 2
//        case .pageThree:
//            return 3
//        }
//    }
//}

class TutorialVC: UIViewController {

//   private var pageController: UIPageViewController?
//    private var pages: [Pages] = Pages.allCases
//    private var currentIndex: Int = 0
    
//
    @IBOutlet weak var skipBtn: UIButton!
    
    fileprivate let items = [
    OnboardingItemInfo(informationImage: UIImage(named: "watering-can-altered")!,
                       title: "My Garden",
                       description: "  Get recommendations for bee-friendly plants for your backyard and track how much you water your plants. We utilise rainfall records to give you results for your water tracking",
                       pageIcon: #imageLiteral(resourceName: "icons8-sprout-100"),
                       color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                       titleColor: UIColor.white, descriptionColor:  UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
    
    OnboardingItemInfo(informationImage: UIImage(named: "flowerred5-altered")!,
                       title: "My Observations",
                       description: "  When you find a bee in your backyard, you can capture the image and store it in the app's gallery. If you like you can also contribute to the researchers by uploading the bee image to the Inaturalist website.",
                       pageIcon: #imageLiteral(resourceName: "icons8-camera-100"),
                       color: UIColor(red: 0.40, green: 0.69, blue: 0.71, alpha: 1.00),
                       titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
    
    OnboardingItemInfo(informationImage: UIImage(named: "naturesprut-altered")!,
                       title: "Explore bee-world around you",
                       description: "  Explore the bee-keeping clubs, museums, bee-farms and nurseries. They are just a tap away. ",
                       pageIcon: #imageLiteral(resourceName: "icons8-museum-100"),
                       color: UIColor(red: 0.61, green: 0.56, blue: 0.74, alpha: 1.00),
                       titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
    
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skipBtn.isHidden = true

        setupPaperOnboardingView()

        view.bringSubviewToFront(skipBtn)
//
//      //  self.view.backgroundColor = .lightGray
//
//        self.setupPageController()
    }
    
    
    @IBAction func skipBtnAct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
//    private func setupPageController() {
//
//        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        self.pageController?.dataSource = self
//        self.pageController?.delegate = self
//        self.pageController?.view.backgroundColor = .clear
//        self.pageController?.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
//        self.addChild(self.pageController!)
//        self.view.addSubview(self.pageController!.view)
//
//        let initialVC = PageVC(with: pages[0])
//
//        self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
//
//        self.pageController?.didMove(toParent: self)
//
//
//    }
    
    private func setupPaperOnboardingView() {
          let onboarding = PaperOnboarding()
          onboarding.delegate = self
          onboarding.dataSource = self
          onboarding.translatesAutoresizingMaskIntoConstraints = false
          view.addSubview(onboarding)

          // Add constraints
          for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
              let constraint = NSLayoutConstraint(item: onboarding,
                                                  attribute: attribute,
                                                  relatedBy: .equal,
                                                  toItem: view,
                                                  attribute: attribute,
                                                  multiplier: 1,
                                                  constant: 0)
              view.addConstraint(constraint)
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

//extension TutorialVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//
//func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//
//    guard let currentVC = viewController as? PageVC else {
//        return nil
//    }
//
//    var index = currentVC.page.index
//
//    if index == 0 {
//        return nil
//    }
//
//    index -= 1
//
//    let vc: PageVC = PageVC(with: pages[index])
//
//    return vc
//}
//
//func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//
//    guard let currentVC = viewController as? PageVC else {
//        return nil
//    }
//
//    var index = currentVC.page.index
//
//    if index >= self.pages.count - 1 {
//        return nil
//    }
//
//    index += 1
//
//    let vc: PageVC = PageVC(with: pages[index])
//
//    return vc
//}
//
//func presentationCount(for pageViewController: UIPageViewController) -> Int {
//    return self.pages.count
//}
//
//func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//    return self.currentIndex
//}
//
//}

private extension TutorialVC {
    
    static let titleFont = UIFont(name: "Nunito-Bold", size: 30.0) ?? UIFont.boldSystemFont(ofSize: 30.0)
    static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
}

// MARK: PaperOnboardingDelegate

extension TutorialVC: PaperOnboardingDelegate {

    func onboardingWillTransitonToIndex(_ index: Int) {
        skipBtn.isHidden = index == 2 ? false : true
    }

    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
        // configure item
        
        //item.titleLabel?.backgroundColor = .redColor()
        //item.descriptionLabel?.backgroundColor = .redColor()
        //item.imageView = ...
        item.descriptionLabel?.textAlignment = .natural
       
    }
}

extension TutorialVC : PaperOnboardingDataSource {

    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }

    func onboardingItemsCount() -> Int {
        return 3
    }
    
        func onboardinPageItemRadius() -> CGFloat {
            return 2
        }
    //
    //    func onboardingPageItemSelectedRadius() -> CGFloat {
    //        return 10
    //    }
    //    func onboardingPageItemColor(at index: Int) -> UIColor {
    //        return [UIColor.white, UIColor.red, UIColor.green][index]
    //    }
}
