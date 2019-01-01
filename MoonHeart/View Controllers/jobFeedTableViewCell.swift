//
//  jobFeedTableViewCell.swift
//  MoonHeart
//
//  Created by Iwan Siauw on 12/21/18.
//  Copyright © 2018 Iwan Siauw. All rights reserved.
//

import UIKit

class jobFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var desc: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
