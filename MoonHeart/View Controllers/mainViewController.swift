//
//  mainViewController.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 12/17/18.
//  Copyright © 2018 Iwan Siauw. All rights reserved.
//

import UIKit


class mainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        
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
