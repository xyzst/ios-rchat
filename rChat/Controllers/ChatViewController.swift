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
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = ApplicationConstants.APPLICATION_DISPLAY_NAME
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: ApplicationConstants.CELL_NIB_NAME, bundle: nil), forCellReuseIdentifier: ApplicationConstants.CELL_IDENTIFIER)
        reloadMessages()
    }
    
    func reloadMessages() {
        db.collection(ApplicationConstants.MESSAGES_COLLECTION).order(by: ApplicationConstants.DATE_FIELD).addSnapshotListener { (query, err) in
            if let e = err {
                print("Unable to retrieve data from persistence store: \(e)")
            } else {
                self.messages = []
                if let q = query?.documents {
                    for m in q {
                        let d = m.data()
                        if let s = d[ApplicationConstants.SENDER_FIELD] as? String, let b = d[ApplicationConstants.BODY_FIELD] as? String {
                            self.messages.append(Message(sender: s, body: b))
                            
                            // allows update ui from main thread
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(item: self.messages.count - 1, section: 0) // scroll to last item of table view, in the first section
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let body = messageTextfield.text, let sender = Auth.auth().currentUser?.email {
            // send data to firestore
            db.collection(ApplicationConstants.MESSAGES_COLLECTION).addDocument(data: [
                ApplicationConstants.SENDER_FIELD: sender,
                ApplicationConstants.BODY_FIELD: body,
                ApplicationConstants.DATE_FIELD: Date().timeIntervalSince1970
            ]) { (e) in
                if let err = e {
                    print("Unable to save the data: \(err)")
                } else {
                    print("Message saved successfully!")
                }
            }
        }
        
        // clear text field after the send button is pressed
        DispatchQueue.main.async {
            self.messageTextfield.text = ""
        }
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
        let message = messages[indexPath.row]
        let c = tableView.dequeueReusableCell(withIdentifier: ApplicationConstants.CELL_IDENTIFIER, for: indexPath) as! MessageCell
        c.label.text = message.body
        if let currUser = Auth.auth().currentUser?.email {
            if currUser == message.sender {
                c.leftImageView.isHidden = true
                c.rightImageView.isHidden = false
                c.messageBubble.backgroundColor = UIColor(named: ApplicationConstants.LIGHT_PURPLE)
                c.label.textColor = UIColor(named: ApplicationConstants.PURPLE)
            } else {
                c.leftImageView.isHidden = false
                c.rightImageView.isHidden = true
                c.messageBubble.backgroundColor = UIColor(named: ApplicationConstants.PURPLE)
                c.label.textColor = UIColor(named: ApplicationConstants.LIGHT_PURPLE)
            }
        }
        return c
    }
}
