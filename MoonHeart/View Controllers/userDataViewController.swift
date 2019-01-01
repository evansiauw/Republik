//
//  userDataViewController.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 11/6/18.
//  Copyright © 2018 Iwan Siauw. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class userDataViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userAge: UITextField!
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var imageButton: UIButton!

    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        picker.delegate = self

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func selectProfileImage(_ sender: UIButton) {
        
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromImagePicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromImagePicker = editedImage
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromImagePicker = originalImage
        }
        
        if let selectedImage = selectedImageFromImagePicker {
            
            imageButton.setImage(selectedImage, for: .normal)
            imageButton.setTitle("", for: .normal)
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitData(_ sender: UIButton) {
        
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profilePics/\(imageName).jpg")
    
        if let uploadData = imageButton.currentImage?.compressImage() {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                guard let metadata = metadata else {
                    return
                }
                print(metadata)
                
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    let values = ["name": self.userName.text!, "age": self.userAge.text!, "image": downloadURL.absoluteString] as [String : Any]
                    
                    self.uploadToCloud(values: values)
                }
            })
            
            self.performSegue(withIdentifier: "tabBar", sender: self)
        }
        
    }
    
    func uploadToCloud(values: [String:Any]){
        
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("Users").child(uid!).updateChildValues(values, withCompletionBlock: { (err,ref) in
            
            if err != nil {
                print (err as Any)
                return
            }
            
        })
    }
    
}

extension UIImage {
    
    func compressImage() -> Data? {
        // Reducing file size to a 10th
        var actualHeight: CGFloat = self.size.height
        var actualWidth: CGFloat = self.size.width
        let maxHeight: CGFloat = 1136.0
        let maxWidth: CGFloat = 640.0
        var imgRatio: CGFloat = actualWidth/actualHeight
        let maxRatio: CGFloat = maxWidth/maxHeight
        var compressionQuality: CGFloat = 0.1
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 1
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let imageData = img!.jpegData(compressionQuality: compressionQuality)
        return imageData
    }
}
