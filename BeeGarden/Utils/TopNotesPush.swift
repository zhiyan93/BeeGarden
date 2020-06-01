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
        let description = EKProperty.LabelContent(text: message, style: .init(font: .systemFont(ofSize: 18), color: .text))
                let image = EKProperty.ImageContent(image: icon, size: CGSize(width: 40, height: 40))
                let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
                let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

                let contentView = EKNotificationMessageView(with: notificationMessage)
                
                attributes.screenInteraction = .dismiss
                attributes.displayDuration = 3
                SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    static func bottomFormPush(title:String,placeHoders:[String],buttonTitle: String,action: @escaping (String) -> ()){
         var attributes = EKAttributes()
         attributes = EKAttributes.toast
        let titleLabel = EKProperty.LabelContent(text: title, style: .init(font: .systemFont(ofSize: 30), color: .white))
        var fields = [EKProperty.TextFieldContent]()
        for s in placeHoders{
            let placeHoder = EKProperty.LabelContent(text: s, style: .init(font: .systemFont(ofSize: 12), color: .white))
            let TextField = EKProperty.TextFieldContent(keyboardType: .numberPad, placeholder: placeHoder, tintColor: .amber, displayMode: .light, textStyle: .init(font: .systemFont(ofSize: 15), color: .satCyan), isSecure: false, leadingImage:.none , bottomBorderColor: .black, accessibilityIdentifier: s)
            fields.append(TextField)
        }
        let buttonLabel = EKProperty.LabelContent(text: buttonTitle, style: .init(font: .systemFont(ofSize: 20), color: .white))
        let button = EKProperty.ButtonContent(label: buttonLabel, backgroundColor: .amber, highlightedBackgroundColor: .chatMessage)
        {
            action(fields[0].textContent)
            print(fields[0].textContent)
            
            
        }
        
         let formContentView = EKFormMessageView(with: titleLabel, textFieldsContent: fields, buttonContent: button)
                attributes.screenInteraction = .dismiss
                attributes.displayDuration = .infinity
                
                attributes.lifecycleEvents.didAppear = {
                           formContentView.becomeFirstResponder(with: 0)
                       }
                
                attributes = .toast
                    
                       attributes.windowLevel = .normal
                       attributes.position = .bottom
                       attributes.displayDuration = .infinity
                       attributes.entranceAnimation = .init(
                           translate: .init(
                               duration: 0.65,
                               spring: .init(damping: 1, initialVelocity: 0)
                           )
                       )
                       attributes.exitAnimation = .init(
                           translate: .init(
                               duration: 0.65,
                               spring: .init(damping: 1, initialVelocity: 0)
                           )
                       )
                       attributes.popBehavior = .animated(
                           animation: .init(
                               translate: .init(
                                   duration: 0.65,
                                   spring: .init(damping: 1, initialVelocity: 0)
                               )
                           )
                       )
                       attributes.entryInteraction = .absorbTouches
                       attributes.screenInteraction = .dismiss
                       attributes.entryBackground = .gradient(
                           gradient: .init(
                               colors: [Color.Netflix.light, Color.Netflix.dark],
                               startPoint: .zero,
                               endPoint: CGPoint(x: 1, y: 1)
                           )
                       )
                       attributes.shadow = .active(
                           with: .init(
                               color: .black,
                               opacity: 0.3,
                               radius: 3
                           )
                       )
                       attributes.screenBackground = .color(color: .dimmedDarkBackground)
                       attributes.scroll = .edgeCrossingDisabled(swipeable: true)
                       attributes.statusBar = .light
                       attributes.positionConstraints.keyboardRelation = .bind(
                           offset: .init(
                               bottom: 0,
                               screenEdgeResistance: 0
                           )
                       )
                       attributes.positionConstraints.maxSize = .init(
                           width: .constant(value: UIScreen.main.minEdge),
                           height: .intrinsic
                       )
        //        attributes.positionConstraints.maxSize = .init(
        //            width: .constant(value: UIScreen.main.bounds.width - 20),
        //            height: .constant(value: UIScreen.main.bounds.height / 2)
        //        )
                SwiftEntryKit.display(entry: formContentView, using: attributes, presentInsideKeyWindow: true)
        
    }
    
    static func ratingPush() {
        var attributes = EKAttributes()
                   attributes = .centerFloat
               attributes.displayMode = .light
                    attributes.windowLevel = .alerts
                    attributes.displayDuration = .infinity
                    attributes.hapticFeedbackType = .success
                    attributes.screenInteraction = .absorbTouches
                    attributes.entryInteraction = .absorbTouches
                    attributes.scroll = .disabled
                    attributes.screenBackground = .color(color: .dimmedLightBackground)
                    attributes.entryBackground = .visualEffect(style: .standard)
                    attributes.entranceAnimation = .init(
                        scale: .init(
                            from: 0.9,
                            to: 1,
                            duration: 0.4,
                            spring: .init(damping: 0.8, initialVelocity: 0)
                        ),
                        fade: .init(
                            from: 0,
                            to: 1,
                            duration: 0.3
                        )
                    )
                    attributes.exitAnimation = .init(
                        scale: .init(
                            from: 1,
                            to: 0.4,
                            duration: 0.4,
                            spring: .init(damping: 1, initialVelocity: 0)
                        ),
                        fade: .init(
                            from: 1,
                            to: 0,
                            duration: 0.2
                        )
                    )
                    attributes.positionConstraints.maxSize = .init(
                        width: .constant(value: UIScreen.main.minEdge),
                        height: .intrinsic
                    )
               
               showRatingView(attributes: attributes)
    }
    
   static private func showRatingView(attributes: EKAttributes) {
    
            var selectedIndex = 0
           let unselectedImage = EKProperty.ImageContent(
             image: UIImage(named: "emptydrop128p")!.withRenderingMode(.automatic),
               displayMode: .light,
               tint: .standardContent
           )
           let selectedImage = EKProperty.ImageContent(
             image: UIImage(named: "onedrop128p")!.withRenderingMode(.automatic),
               displayMode: .light,
               tint: EKColor.ratingStar
           )
           let initialTitle = EKProperty.LabelContent(
               text: "Record the watering today!",
               style: .init(
                 font: .systemFont(ofSize: 30),
                   color: .standardContent,
                   alignment: .center,
                   displayMode: .light
               )
           )
           let initialDescription = EKProperty.LabelContent(
               text: "Select the volumn of watering per square",
               style: .init(
                 font: .systemFont(ofSize: 20),
                   color: EKColor.standardContent.with(alpha: 0.5),
                   alignment: .center,
                   displayMode: .light
               )
           )
           let items = [("Slightly", "less than 5L per square"), ("Moisture", "5-10L per square"), ("Moderate", "10-15L per square"),
                        ("Enough", "15-20L per square"), ("Extra", "more than 20L per square")].map { texts -> EKProperty.EKRatingItemContent in
                           let itemTitle = EKProperty.LabelContent(
                               text: texts.0,
                               style: .init(
                                 font: .systemFont(ofSize: 35),
                                   color: .standardContent,
                                   alignment: .center,
                                   displayMode: .light
                               )
                           )
                           let itemDescription = EKProperty.LabelContent(
                               text: texts.1,
                               style: .init(
                                 font: .systemFont(ofSize: 22),
                                   color: .standardContent,
                                   alignment: .center,
                                   displayMode: .light
                               )
                           )
                           return EKProperty.EKRatingItemContent(
                               title: itemTitle,
                               description: itemDescription,
                               unselectedImage: unselectedImage,
                               selectedImage: selectedImage
                           )
           }
           
           var message: EKRatingMessage!
         let lightFont = UIFont.systemFont(ofSize: 24)
           let mediumFont = UIFont.systemFont(ofSize: 20)
           let closeButtonLabelStyle = EKProperty.LabelStyle(
               font: mediumFont,
               color: .standardContent,
               displayMode: .light
           )
           let closeButtonLabel = EKProperty.LabelContent(
               text: "Back",
               style: closeButtonLabelStyle
           )
           let closeButton = EKProperty.ButtonContent(
               label: closeButtonLabel,
               backgroundColor: .clear,
               highlightedBackgroundColor: EKColor.standardBackground.with(alpha: 0.2),
               displayMode: .light) {
                   SwiftEntryKit.dismiss {
                       // Here you may perform a completion handler
                   }
           }
           
           let pinkyColor = EKColor.pinky
           let okButtonLabelStyle = EKProperty.LabelStyle(
               font: lightFont,
               color: pinkyColor,
               displayMode: .light
           )
           let okButtonLabel = EKProperty.LabelContent(
               text: "Record Watering",
               style: okButtonLabelStyle
           )
           let okButton = EKProperty.ButtonContent(
               label: okButtonLabel,
               backgroundColor: .clear,
               highlightedBackgroundColor: pinkyColor.with(alpha: 0.05),
               displayMode: .light)  {
                   SwiftEntryKit.dismiss()
                 print("ok", selectedIndex )
                let dictionary = [1:selectedIndex]
                 NotificationCenter.default.post(name: NSNotification.Name("addWatering"), object: nil,userInfo: dictionary)
            
           }
           let buttonsBarContent = EKProperty.ButtonBarContent(
               with: closeButton, okButton,
               separatorColor: EKColor(light: Color.Gray.light.light, dark: Color.Gray.mid.light),
               horizontalDistributionThreshold: 1,
               displayMode: .light,
               expandAnimatedly: true
           )
           message = EKRatingMessage(
               initialTitle: initialTitle,
               initialDescription: initialDescription,
               ratingItems: items,
               buttonBarContent: buttonsBarContent) { index in
                   // Rating selected - do something
             //   print("index ",index)
                selectedIndex = index
           }
    
         
           let contentView = EKRatingMessageView(with: message)
           SwiftEntryKit.display(entry: contentView, using: attributes)
       }
    
    
    static func centreFloatPush(title: String,desc: String,image: UIImage?) {
        var attributes = EKAttributes()
        attributes = EKAttributes.centerFloat
               attributes.hapticFeedbackType = .success
               attributes.displayDuration = .infinity
               attributes.entryBackground = .gradient(
                   gradient: .init(
                       colors: [EKColor(rgb: 0xfffbd5), EKColor(rgb: 0xf39c12)],// [EKColor(rgb: 0xfffbd5), EKColor(rgb: 0xb20a2c)],
                       startPoint: .zero,
                       endPoint: CGPoint(x: 1, y: 1)
                   )
               )
               attributes.screenBackground = .color(color: .dimmedDarkBackground)
               attributes.shadow = .active(
                   with: .init(
                       color: .black,
                       opacity: 0.3,
                       radius: 10
                   )
               )
               attributes.screenInteraction = .dismiss
               attributes.entryInteraction = .absorbTouches
               attributes.scroll = .enabled(
                   swipeable: true,
                   pullbackAnimation: .jolt
               )
               attributes.roundCorners = .all(radius: 8)
               attributes.entranceAnimation = .init(
                   translate: .init(
                       duration: 0.7,
                       spring: .init(damping: 0.7, initialVelocity: 0)
                   ),
                   scale: .init(
                       from: 0.7,
                       to: 1,
                       duration: 0.4,
                       spring: .init(damping: 1, initialVelocity: 0)
                   )
               )
               attributes.exitAnimation = .init(
                   translate: .init(duration: 0.2)
               )
               attributes.popBehavior = .animated(
                   animation: .init(
                       translate: .init(duration: 0.35)
                   )
               )
               attributes.positionConstraints.size = .init(
                   width: .offset(value: 20),
                   height: .intrinsic
               )
               attributes.positionConstraints.maxSize = .init(
                width: .constant(value: UIScreen.main.bounds.width - 50),
                   height: .intrinsic
               )
               attributes.statusBar = .dark
//               descriptionString = "Centeralized floating popup with dimmed background"
//               descriptionThumb = ThumbDesc.bottomPopup.rawValue
//               description = .init(
//                   with: attributes,
//                   title: "Pop Up II",
//                   description: descriptionString,
//                   thumb: descriptionThumb
//               )
       var themeImage: EKPopUpMessage.ThemeImage?
                
                if let image = image {
                    themeImage = EKPopUpMessage.ThemeImage(
                        image: EKProperty.ImageContent(
                            image: image,
                            displayMode: .light,
                            size: CGSize(width: 40, height: 40),
                            tint: .black,
                            contentMode: .scaleAspectFit
                        )
                    )
                }
                let title = EKProperty.LabelContent(
                    text: title,
                    style: .init(
                      font: .boldSystemFont(ofSize: 24) ,
                      color: .satCyan,
                        alignment: .center,
                        displayMode: .light
                    )
                )
                let description = EKProperty.LabelContent(
                    text: desc,
                    style: .init(
                      font: .systemFont(ofSize: 16),
                      color: .black,
                      alignment: .justified,
                        displayMode: .light
                    )
                )
                let button = EKProperty.ButtonContent(
                    label: .init(
                        text: "Got it!",
                        style: .init(
                          font: .systemFont(ofSize: 16),
                          color: .white,
                          displayMode: .light
                        )
                    ),
                    backgroundColor: .satCyan,
                    highlightedBackgroundColor: .amber
            
                   // displayMode: .greatestFiniteMagnitude
                )
                let message = EKPopUpMessage(
                    themeImage: themeImage,
                    title: title,
                    description: description,
                    button: button) {
                        SwiftEntryKit.dismiss()
                      
                }
                let contentView = EKPopUpMessageView(with: message)
                SwiftEntryKit.display(entry: contentView, using: attributes)
        
    }
    
  

}





extension UIScreen {
    var minEdge: CGFloat {
        return UIScreen.main.bounds.minEdge
    }
}

extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}
