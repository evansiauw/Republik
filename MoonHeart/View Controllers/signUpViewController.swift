//
//  signUpViewController.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 11/6/18.
//  Copyright © 2018 Iwan Siauw. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class signUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordReEnterField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    
    @IBAction func signUp(_ sender: UIButton) {
        
        // TODO: validate username and password (guard or if let)
        // TODO: pass must be six characters or more
        
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (authResult, error) in
            
            guard let user = authResult?.user else { return }
            
            guard let email = self.emailField.text
                else {
                    print("Oops!!! Something is wrong")
                    return
            }
            
            let ref = Database.database().reference(fromURL: "https://moon-heart.firebaseio.com/")
            let userReference = ref.child("Users").child(user.uid)
            let values = ["email": email]
            userReference.updateChildValues(values, withCompletionBlock: { (err,ref) in
                
                if err != nil {
                    print(err as Any)
                    return
                }
            })
            
        })
        
        self.performSegue(withIdentifier: "tabBarController2", sender: self)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func DisplayAlert(Message: String){
        
        let controller = UIAlertController(title: "Attention", message: Message, preferredStyle: .alert)
        
        let action = UIAlertAction(title:"Dismiss", style: .default, handler: nil)
        
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0,y:215), animated: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }

}
