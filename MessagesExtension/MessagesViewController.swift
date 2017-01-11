//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Brandon Moore on 12/31/16.
//  Copyright © 2016 Brandon Moore. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        super.willBecomeActive(with: conversation)
        
        // Present the view controller appropriate for the conversation and presentation style.
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        
        // Present the view controller appropriate for the conversation and presentation style.
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        // Determine the controller to present.
        let controller: UIViewController
        // Show a list of previously created ice creams.
        if presentationStyle == .compact {
            // Show a list of previously created ice creams.
            controller = instantiateStartGameController()
        } else {
            if (conversation.selectedMessage == nil) {
                controller = instantiateStartGameController()
            } else {
                var identity = "placeholder2"
                let message = conversation.selectedMessage
                guard let components = NSURLComponents(url: (message?.url)!, resolvingAgainstBaseURL: false) else {
                    fatalError("The message contains an invalid URL")
                }
                
                if let queryItems = components.queryItems {
                    let location = queryItems[0].value
                    let spyIdentifier = queryItems[1].value
                    if spyIdentifier == conversation.localParticipantIdentifier.uuidString {
                        identity = "Spy"
                    } else {
                        identity = location!
                    }
                }
                controller = instantiateIdentityRevealerController(with: identity)
            }
        }
        
        
        // Remove any existing child controllers.
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        // Embed the new controller.
        addChildViewController(controller)
        
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        controller.didMove(toParentViewController: self)

    }
    
    private func instantiateIdentityRevealerController(with identity: String) -> UIViewController {
        // Instantiate a `IdentityRevealerViewController` and present it.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: IdentityRevealerViewController.storyboardIdentifier) as? IdentityRevealerViewController else { fatalError("Unable to instantiate an IdentityRevealerViewController from the storyboard") }
        
        controller.delegate = self
        controller.identity = identity
        
        return controller
    }
    
    private func instantiateStartGameController() -> UIViewController {
        // Instantiate a `StartGameViewController` and present it.
        guard let controller = storyboard?.instantiateViewController(withIdentifier: StartGameViewController.storyboardIdentifier) as? StartGameViewController else { fatalError("Unable to instantiate an StartGameViewController from the storyboard") }
        
        controller.delegate = self
        
        return controller
    }
    
    fileprivate func composeMessage() {
        let conversation = activeConversation
        let session = conversation?.selectedMessage?.session ?? MSSession()
        
        let layout = MSMessageTemplateLayout()
        //layout.image = UIImage(named: "message-background.png")
        layout.image = UIImage.fromColor(color: .darkGray)
        layout.imageTitle = "iMessage Extension"
        layout.caption = nil
        layout.subcaption = nil
        //layout.subcaption = "Sent by ".appending((conversation?.localParticipantIdentifier.uuidString)!)
        
        var components = URLComponents()
        let locationQueryItem = URLQueryItem(name: "location", value: "Hotel")
        var participantIdentifiers = conversation?.remoteParticipantIdentifiers
        participantIdentifiers?.append((conversation?.localParticipantIdentifier)!)
        let spyIndex = Int(arc4random_uniform(UInt32(participantIdentifiers!.count)))
        let spyQueryItem = URLQueryItem(name: "spy", value: participantIdentifiers?[spyIndex].uuidString)
        components.queryItems = [locationQueryItem, spyQueryItem]
        
        let message = MSMessage(session: session)
        message.layout = layout
        message.url = components.url
        message.summaryText = "Sent Hello World message"
        
        conversation?.insert(message)
    }
    
    
}

extension UIImage {
    static func fromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension MessagesViewController: StartGameViewControllerDelegate {
    func sendStartGameMessage(_ controller: StartGameViewController) {
        composeMessage()
        dismiss()
    }
}

extension MessagesViewController: IdentityRevealerViewControllerDelegate {
    func revealIdentity(_ controller: IdentityRevealerViewController) {
        
    }
}
