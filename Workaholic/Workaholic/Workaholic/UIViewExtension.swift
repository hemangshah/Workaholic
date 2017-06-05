//
//  UIViewExtension.swift
//  Workaholic
//
//  Created by Hemang Shah on 6/5/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import UIKit

extension UIView {
    func getMyWidth() -> CGFloat {
        return self.frame.size.width
    }
    
    func getMyHeight() -> CGFloat {
        return self.frame.size.height
    }
    
    func getMySize() -> CGSize {
        return self.frame.size
    }
}
