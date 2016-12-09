//
//  TextTableViewCell.swift
//  QuickbloxDemo2
//
//  Created by 默司 on 2016/12/9.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    var item: String! {
        didSet{
            label.text = item
        }
    }
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        label.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
