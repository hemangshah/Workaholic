//
//  WHExtensions.swift
//  Workaholic
//
//  Created by Hemang Shah on 8/10/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import UIKit

public extension UIColor {
    public class func colorFromRGB(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
}

public extension UIView {
    public func width() -> Double {
        return Double(self.frame.size.width)
    }
    
    public func height() -> Double {
        return Double(self.frame.size.height)
    }
    
    public func size() -> CGSize {
        return self.frame.size
    }
}

public extension Array {
    public mutating func clean() {
        self.removeAll()
    }
}
