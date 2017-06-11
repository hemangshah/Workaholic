//
//  UIViewExtension.swift
//  Workaholic
//
//  Created by Hemang Shah on 6/5/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import UIKit

public extension UIView {
    func getMyWidth() -> Double {
        return Double(self.frame.size.width)
    }
    
    func getMyHeight() -> Double {
        return Double(self.frame.size.height)
    }
    
    func getMySize() -> CGSize {
        return self.frame.size
    }
}
