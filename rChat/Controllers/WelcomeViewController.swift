//
//  WelcomeViewController.swift
//  rChat
//
//  Created by Darren Rambaud on 02/19/2019.
//  Copyright © 2020 Darren Rambaud. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        
        let title = "⚡️rChat"
        var i = 0.0
        for c in title {
            Timer.scheduledTimer(withTimeInterval: 0.15 * i, repeats: false) { (t) in
                self.titleLabel.text?.append(c)
            }
            i += 1
        }
    }
    

}
