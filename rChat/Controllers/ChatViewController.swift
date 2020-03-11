//
//  ChatViewController.swift
//  rChat
//
//  Created by Darren Rambaud on 02/19/2020.
//  Copyright © 2020 Darren Rambaud. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "Hey!"),
        Message(sender: "2@3.com", body: "Yo!"),
        Message(sender: "1@2.com", body: "What's good?")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = ApplicationConstants.APPLICATION_DISPLAY_NAME
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let auth = Auth.auth()
        
        do {
            try auth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let e as NSError {
            print("Unable to sign out: %@", e)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: ApplicationConstants.CELL_IDENTIFIER, for: indexPath)
        
        c.textLabel?.text = messages[indexPath.row].body
        
        return c
    }
}
