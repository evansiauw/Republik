//
//  newsTableViewCell.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 1/9/19.
//  Copyright © 2019 Iwan Siauw. All rights reserved.
//

import UIKit

class newsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var images: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
