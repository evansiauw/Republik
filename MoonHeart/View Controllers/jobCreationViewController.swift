//
//  jobCreationViewController.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 12/24/18.
//  Copyright © 2018 Iwan Siauw. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class jobCreationViewController: UIViewController {
    
    var cities = ["Select A City","Boston", "Los Angeles", "New York", "Philadelphia", "San Francisco"]
    var jobTypes = ["Select Employment Type","Full Time", "Part Time", "Contract"]
    
    var citySelected: String?
    var employmentSelected: String?
    
    var db: Firestore!
    
    @IBOutlet weak var cityName: UIButton!
    @IBOutlet weak var employmentType: UIButton!
    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var salary: UITextField!
    @IBOutlet weak var desc: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
    }
    
    @IBAction func submitPosting(_ sender: UIBarButtonItem) {
        
        if let jobTitle = jobTitle.text, let salary = salary.text, let desc = desc.text, let city = citySelected, let employment = employmentSelected {
            
            let newJobFeed = jobFeed(
                title: jobTitle.uppercased(),
                subtitle:employment,
                value: salary,
                desc: desc,
                time: Date())
            
            db.collection(city).addDocument(data: newJobFeed.dictionary){err in
                if let err = err {
                    self.DisplayAlert(Message: "Oops!!! There's something wrong writing to the database")
                    print("Error writing document: \(err)")
                } else {
                    //self.DisplayAlert(Message: "Job Posting has been successfuly posted")
                    print("Document successfully written!")
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
        } else {
            DisplayAlert(Message: "Please fill in all fields")
        }
        
    }
    
    @IBAction func selectCity(_ sender: UIButton) {
        
        let alert = UIAlertController(style: .actionSheet)
        //let frameSizes: [CGFloat] = (150...400).map { CGFloat($0) }
        //let pickerViewValues: [[String]] = [frameSizes.map { Int($0).description }]
        
        let pickerViewValues: [[String]] = [cities]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    //vc.preferredContentSize.height = cities[index.row]
                }
            }
            
            self.cityName.setTitle(self.cities[index.row], for: .normal)
            print("select city \(index.row) ")
            if (index.row != 0){
                self.citySelected = self.cities[index.row]
            } else {
                self.citySelected = nil
            }
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()

    }
    
    @IBAction func employmentType(_ sender: UIButton) {
        
        let alert = UIAlertController(style: .actionSheet)
        //let frameSizes: [CGFloat] = (150...400).map { CGFloat($0) }
        //let pickerViewValues: [[String]] = [frameSizes.map { Int($0).description }]
        
        let pickerViewValues: [[String]] = [jobTypes]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    //vc.preferredContentSize.height = cities[index.row]
                }
            }
            
            self.employmentType.setTitle(self.jobTypes[index.row], for: .normal)
            
            if (index.row != 0){
                self.employmentSelected = self.jobTypes[index.row]
            } else {
                self.employmentSelected = nil
            }
            
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
        
    }
    
    func DisplayAlert(Message: String){
        
        let controller = UIAlertController(title: "Attention", message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title:"Dismiss", style: .default, handler: nil)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }

    
 

}
