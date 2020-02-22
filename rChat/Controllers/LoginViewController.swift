//
//  LoginViewController.swift
//  rChat
//
//  Created by Darren Rambaud on 02/19/2020.
//  Copyright © 2020 Darren Rambaud. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let e = emailTextfield.text, let p = passwordTextfield.text {
            Auth.auth().signIn(withEmail: e, password: p) {
                authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "fromLogin", sender: self)
                }
            }
        }
    }
}
