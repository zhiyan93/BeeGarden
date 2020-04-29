//
//  TopNotesPush.swift
//  BeeGarden
//
//  Created by steven liu on 27/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import Foundation
import SwiftEntryKit

//notification on top and bottom push
struct TopNotesPush {
    static func push(message: String,color: EKAttributes.BackgroundStyle){
        var attributes = EKAttributes()
        attributes = .topNote
               attributes.displayMode = EKAttributes.DisplayMode.inferred
               attributes.name = "Top Note"
               attributes.hapticFeedbackType = .success
               attributes.popBehavior = .animated(animation: .translation)
         attributes.displayDuration = 3
        attributes.entryBackground = color
               attributes.shadow = .active(
                   with: .init(
                       color: .chatMessage,
                       opacity: 0.5,
                       radius: 2
                   )
               )
        
        let text = message
        let style = EKProperty.LabelStyle(
         font: UIFont.systemFont(ofSize: 17),
            color: .white,
            alignment: .center
        )
        let labelContent = EKProperty.LabelContent(
            text: text,
            style: style
        )
        let contentView = EKNoteMessageView(with: labelContent)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    static func bottomPush(message:String, title: String, icon: UIImage, color: EKColor){
         var attributes = EKAttributes()
        attributes = EKAttributes.bottomFloat
                attributes.entryBackground = .color(color: .standardBackground)
        //            .gradient(gradient: .init(colors: [EKColor(.red), EKColor(.green)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
                attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                attributes.statusBar = .dark
                attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .intrinsic)

        let title = EKProperty.LabelContent(text: title, style: .init(font: .systemFont(ofSize: 22), color: color))
        let description = EKProperty.LabelContent(text: message, style: .init(font: .systemFont(ofSize: 18), color: .black))
                let image = EKProperty.ImageContent(image: icon, size: CGSize(width: 40, height: 40))
                let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
                let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

                let contentView = EKNotificationMessageView(with: notificationMessage)
                
                attributes.screenInteraction = .dismiss
                attributes.displayDuration = 4
                SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
