//
//  DesignResizable.swift
//  Gotyou
//
//  Created by 默司 on 2016/12/4.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

protocol DesignResizable {
    func scaleRate(designWidth width: CGFloat) -> CGFloat
}

extension DesignResizable {
    func scaleRate(designWidth width: CGFloat = 1080) -> CGFloat {
        let size = UIScreen.main.bounds.size
        
        return min(size.width, size.height) / width
    }
}
