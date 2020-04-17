//
//  TutorialVC.swift
//  BeeGarden
//
//  Created by steven liu on 18/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit

enum Pages: CaseIterable {
    case pageZero
    case pageOne
    case pageTwo
    case pageThree
    
    var name: String {
        switch self {
        case .pageZero:
            return "This is page zero"
        case .pageOne:
            return "This is page one"
        case .pageTwo:
            return "This is page two"
        case .pageThree:
            return "This is page three"
        }
    }
    
    var index: Int {
        switch self {
        case .pageZero:
            return 0
        case .pageOne:
            return 1
        case .pageTwo:
            return 2
        case .pageThree:
            return 3
        }
    }
}

class TutorialVC: UIViewController {

   private var pageController: UIPageViewController?
    private var pages: [Pages] = Pages.allCases
    private var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.view.backgroundColor = .lightGray
        
        self.setupPageController()
    }
    
    private func setupPageController() {
        
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .clear
        self.pageController?.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
        self.addChild(self.pageController!)
        self.view.addSubview(self.pageController!.view)
        
        let initialVC = PageVC(with: pages[0])
        
        self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        
        self.pageController?.didMove(toParent: self)
        
       
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

extension TutorialVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
    guard let currentVC = viewController as? PageVC else {
        return nil
    }
    
    var index = currentVC.page.index
    
    if index == 0 {
        return nil
    }
    
    index -= 1
    
    let vc: PageVC = PageVC(with: pages[index])
    
    return vc
}

func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
    guard let currentVC = viewController as? PageVC else {
        return nil
    }
    
    var index = currentVC.page.index
    
    if index >= self.pages.count - 1 {
        return nil
    }
    
    index += 1
    
    let vc: PageVC = PageVC(with: pages[index])
    
    return vc
}

func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return self.pages.count
}

func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return self.currentIndex
}

}
