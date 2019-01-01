//
//  profileViewController.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 11/6/18.
//  Copyright © 2018 Iwan Siauw. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class profileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAge: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.roundedCorner()
        //getProfileInfo()
    }
    
    func getProfileInfo(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("Users").child(uid!).observeSingleEvent(of:DataEventType.value, with: {
            (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            self.userName.text = postDict["name"] as? String
            let age = postDict["age"] as? String
            self.userAge.text = "Age: \(age!)"
            self.userEmail.text = postDict["email"] as? String
           
            let imageUrl = postDict["image"] as? String
            
            let httpRef = Storage.storage().reference(forURL: imageUrl!)
            
            httpRef.getData(maxSize: 1 * 1024 * 1024, completion: { data, error in
                if let error = error {
                    print(error)
                } else {
                    self.userImage.image = UIImage(data: data!)
                }
            })
            
        }, withCancel: nil)
    }
    
    // check if this is working
    @IBAction func signOut(_ sender: UIBarButtonItem) {
       /*
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            let vc = storyboard.instantiateViewController(withIdentifier: "mainView") as UIViewController
            //            navigationController?.pushViewController(vc, animated: true)
            //
            //            present(mainViewController, animated: true, completion: nil)
            
            performSegue(withIdentifier: "mainMenu", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
 */
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        
        
        return cell
    }

}



