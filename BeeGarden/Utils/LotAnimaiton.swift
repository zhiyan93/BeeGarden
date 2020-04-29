//
//  LotAnimaiton.swift
//  BeeGarden
//
//  Created by steven liu on 30/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import Foundation
import Lottie
struct LotAnimation {
    static func setAnimation(logoAnimation: AnimationView,size: CGFloat ,view: UIView){
        
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
}
