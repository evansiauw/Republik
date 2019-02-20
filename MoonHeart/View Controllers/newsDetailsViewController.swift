//
//  newsDetailsViewController.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 1/25/19.
//  Copyright © 2019 Iwan Siauw. All rights reserved.
//

import UIKit

class newsDetailsViewController: UIViewController {

    var titles = "Not Available"
    var details = "Not Available"
    var image: UIImage?
    
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsDetails: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTitle.text = titles
        newsDetails.text = details
        
        if let image = self.image {
            newsImage.image = image
        }

    }


}
