//
//  UIimage.swift
//  Gotyou
//
//  Created by 默司 on 2016/12/1.
//  Copyright © 2016年 默司. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static func image(named: String, in bundle: Bundle? = Bundle(identifier: "com.gotyou.app")) -> UIImage {
        return UIImage(named: named, in: bundle, compatibleWith: nil)!
    }
    
    func resize(max: CGFloat) -> UIImage? {
        
        var image: UIImage?
        
        if self.size.width > self.size.height {
            let scale = max / self.size.width
            let height = self.size.height * scale
            UIGraphicsBeginImageContext(CGSize(width: max, height: height))
            draw(in: CGRect(x: 0, y: 0, width: max, height: height))
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        } else {
            let scale = max / self.size.height
            let width = self.size.width * scale
            UIGraphicsBeginImageContext(CGSize(width: width, height: max))
            draw(in: CGRect(x: 0, y: 0, width: width, height: max))
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        return image
    }
}
