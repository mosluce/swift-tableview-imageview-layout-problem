//
//  UIFont+DesignResizable.swift
//  Gotyou
//
//  Created by 默司 on 2016/12/4.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

extension UIFont : DesignResizable {}
extension UIFont {
    func withDesignedSize(_ designedFontSize: CGFloat) -> UIFont {
        return self.withSize(designedFontSize * scaleRate())
    }
}
