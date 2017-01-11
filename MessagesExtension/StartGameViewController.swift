//
//  StartGameViewController.swift
//  SpyHunter
//
//  Created by Brandon Moore on 1/2/17.
//  Copyright © 2017 Brandon Moore. All rights reserved.
//

import UIKit

class StartGameViewController: UIViewController {
    
    static let storyboardIdentifier = "StartGameViewController"
    
    weak var delegate: StartGameViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapStartGame(_ sender: Any) {
        // Call the delegate with the body part for the centered cell.
        delegate?.sendStartGameMessage(self)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

/**
 A delegate protocol for the `StartGameViewController` class.
 */
protocol StartGameViewControllerDelegate: class {
    /// Called when the user taps to Start Game in `StartGameViewController`.
    func sendStartGameMessage(_ controller: StartGameViewController)
}
