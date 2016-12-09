//
//  ImageTableViewCell.swift
//  QuickbloxDemo2
//
//  Created by 默司 on 2016/12/9.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    var item: UIImage! {
        didSet {
            photoView.image = item
        }
    }
    
    @IBOutlet weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        photoView.image = nil
        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
