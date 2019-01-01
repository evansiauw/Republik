//
//  loginViewController.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 11/5/18.
//  Copyright © 2018 Iwan Siauw. All rights reserved.
//

import UIKit
import FirebaseAuth

class loginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        if(emailField.text != "" && passwordField.text != ""){
            
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!, completion: {(user,error) in
                
                if user != nil
                {
                    self.performSegue(withIdentifier: "tabBarController1", sender: self)
                }
                else{
                    
                    if let myError = error?.localizedDescription
                    {
                        print(myError)
                        self.DisplayAlert(Message: "Email or password is invalid");
                        
                    }
                    else{
                        print("ERROR")
                    }
                }
                
                
            })
        } else {
            self.DisplayAlert(Message: "Please Don't leave it empty")
        }
        
    }
    
    // TODO: Not yet Implemented
    @IBAction func forgotPassword(_ sender: UIButton) {
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    
    func DisplayAlert(Message: String){
        
        let controller = UIAlertController(title: "Attention", message: Message, preferredStyle: .alert)
        
        let action = UIAlertAction(title:"Dismiss", style: .default, handler: {(paramAction:UIAlertAction!)
            in print("alert displayed")})
        
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
}
