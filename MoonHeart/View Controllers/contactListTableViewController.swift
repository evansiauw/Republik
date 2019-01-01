//
//  contactListTableViewController.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 11/9/18.
//  Copyright © 2018 Iwan Siauw. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class contactListTableViewController: UITableViewController {
    
    var contacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContact()
    }
    
    func fetchContact() {
        Database.database().reference().child("Users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                
                let contact = Contact()
                contact.setValuesForKeys(dictionary)
                self.contacts.append(contact)
                
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
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        let value = contacts[indexPath.row]
        
        let imageRef = value.image
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
        
        cell.textLabel?.text = value.name
        cell.detailTextLabel?.text = value.email
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMessage"{
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let value = contacts[indexPath.row]
                
                let destination = segue.destination as! ViewController
                
                destination.navigationItem.title = value.name
                
            }
            
        }
        
    }

    
}
