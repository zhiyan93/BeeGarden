//
//  addRecordVC.swift
//  BeeGarden
//
//  Created by steven liu on 26/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit

class addRecordVC: UIViewController {

//  lazy var backdropView: UIView = {
//        let bdView = UIView(frame: self.view.bounds)
//        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        return bdView
//    }()
//
//    let menuView = UIView()
//    let menuHeight = UIScreen.main.bounds.height / 2
//    var isPresenting = false
//
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        modalPresentationStyle = .custom
//        transitioningDelegate = self
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = .clear
//        view.addSubview(backdropView)
//        view.addSubview(menuView)
//
//        menuView.backgroundColor = .white
//        menuView.translatesAutoresizingMaskIntoConstraints = false
//        menuView.heightAnchor.constraint(equalToConstant: menuHeight).isActive = true
//        menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        menuView.layer.cornerRadius = 10
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addRecordVC.handleTap(_:)))
      //  backdropView.addGestureRecognizer(tapGesture)
    }

    @IBAction func panGesture(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        dismiss(animated: true, completion: nil)
//    }
    }

//    extension addRecordVC: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return self
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return self
//    }
//
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 1
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let containerView = transitionContext.containerView
//        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
//        guard let toVC = toViewController else { return }
//        isPresenting = !isPresenting
//
//        if isPresenting == true {
//            containerView.addSubview(toVC.view)
//
//            menuView.frame.origin.y += menuHeight
//            backdropView.alpha = 0
//
//            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
//                self.menuView.frame.origin.y -= self.menuHeight
//                self.backdropView.alpha = 1
//            }, completion: { (finished) in
//                transitionContext.completeTransition(true)
//            })
//        } else {
//            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
//                self.menuView.frame.origin.y += self.menuHeight
//                self.backdropView.alpha = 0
//            }, completion: { (finished) in
//                transitionContext.completeTransition(true)
//            })
//        }
//    }
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

