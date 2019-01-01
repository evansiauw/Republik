//
//  messageViewController.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 11/8/18.
//  Copyright © 2018 Iwan Siauw. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class messageViewController: UITableViewController{

    var messages = [Messages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFeed()

    }
    
    func fetchFeed() {
        
        Database.database().reference().child("Message").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                
                let message = Messages()
                message.setValuesForKeys(dictionary)
                self.messages.append(message)
                
                //NEED TO BE OPTIMIZED USING NSCACHE
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        }, withCancel: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! messageTableViewCell
        
        let value = messages[indexPath.row]
        
        let imageRef = value.senderImage
        let httpRef = Storage.storage().reference(forURL: imageRef!)
        
        httpRef.getData(maxSize: 1 * 1024 * 1024, completion: { data, error in
            if let error = error {
                print(error)
            } else {
                
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data!)
                }
            }
        })
        
        cell.textLabel?.text = value.senderName
        cell.detailTextLabel?.text = value.message
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "messageDetails"{
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let value = messages[indexPath.row]
                
                let destination = segue.destination as! ViewController
                
                destination.navigationItem.title = value.senderName
                
            }
            
        }
        
    }

}

