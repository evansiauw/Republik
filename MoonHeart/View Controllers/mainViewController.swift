//
//  mainViewController.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 12/17/18.
//  Copyright © 2018 Iwan Siauw. All rights reserved.
//

import UIKit

class mainViewController: UIViewController {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        getWeatherByZipcode()

    }
    
    func getWeatherByZipcode(){
        
        let singleWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
        let openWeatherMapAPIKey = "4c91b5146f025d9c3b07ee004aa64af3"
        let unit = "imperial"
        let zipcode = 11373
        let session = URLSession.shared
        let weatherRequestURL = URL(string: "\(singleWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&zip=\(zipcode)&units=\(unit)")!
        
        // The data task retrieves the data.
        let dataTask = session.dataTask(with: weatherRequestURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Error:\n\(error)")
            } else {
                if let data = data {
//                    let dataString = String(data: data, encoding: String.Encoding.utf8)
//                    print("All the weather data:\n\(dataString!)")
                    
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                        
                        if let weatherArray = jsonObj!.value(forKey: "weather") as? [Any], let weatherDict = weatherArray[0] as? NSDictionary, let icon = weatherDict.value(forKey: "icon") as? String{
                            self.getWeatherIcons(icon: icon)

                        }

                        if let mainArray = jsonObj!.value(forKey: "main") as? NSDictionary, let temp = mainArray.value(forKey: "temp") as? Double, let minTemp = mainArray.value(forKey: "temp_min") as? Double, let maxTemp = mainArray.value(forKey: "temp_max") as? Double{
                            
                            DispatchQueue.main.async {
                                self.tempLabel.text = "\(Int(temp))F"
                                self.maxTempLabel.text = "Hi: \(Int(maxTemp))  Lo: \(Int(minTemp))"
                            }
                            
                        } else {
                            print("Error: unable to convert json data")
                        }
                        
                        
                        if let name = jsonObj!.value(forKey: "name") as? String {
                            
                            DispatchQueue.main.async {
                                self.cityLabel.text = "\(name)"
                                
                            }
                        } else {
                            print("Error: name not found")
                        }
                        
                        
                    } else {
                        print("Error: did not receive data")
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    func getWeatherIcons(icon: String){
        
        let iconURL = "http://openweathermap.org/img/w/"
        let iconRequestURL = URL(string: "\(iconURL)\(icon).png")
        let session = URLSession.shared
        
        print(iconRequestURL!)
        
        // The data task retrieves the data.
        let dataTask = session.dataTask(with: iconRequestURL!) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Error:\n\(error)")
            } else {
                if let image = data {
                    
                    DispatchQueue.main.async {
                        self.iconImage.image = UIImage(data: image)

                    }
                }
            }
        }
        dataTask.resume()
        
    }
    
    
    func style(){
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "PartyLetPlain", size: 30)!
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attrs
        
        navigationController?.navigationBar.barTintColor = UIColor.red
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

// FIX - if weather reaches triple digits, the number should shrink
