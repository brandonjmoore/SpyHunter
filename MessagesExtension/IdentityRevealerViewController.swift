//
//  MessageViewController.swift
//  SpyHunter
//
//  Created by Brandon Moore on 1/2/17.
//  Copyright © 2017 Brandon Moore. All rights reserved.
//

import Foundation
import Messages

class IdentityRevealerViewController: UIViewController {
    
    static let storyboardIdentifier = "IdentityRevealerViewController"
    
    var identity: String = "Placeholder"
    
    weak var delegate: IdentityRevealerViewControllerDelegate?
    
    @IBOutlet weak var identityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        identityLabel.text = identity
    }

}

/**
 A delegate protocol for the `IdentityRevealerViewController` class.
 */
protocol IdentityRevealerViewControllerDelegate: class {
    /// Called when the user taps to Start Game in `IdentityRevealerViewController`.
    func revealIdentity(_ controller: IdentityRevealerViewController)
}
