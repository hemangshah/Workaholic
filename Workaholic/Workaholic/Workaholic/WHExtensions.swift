//
//  WHExtensions.swift
//  Workaholic
//
//  Created by Hemang Shah on 8/10/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import UIKit

public extension UIView {
    func width() -> Double {
        return Double(self.frame.size.width)
    }
    
    func height() -> Double {
        return Double(self.frame.size.height)
    }
    
    func size() -> CGSize {
        return self.frame.size
    }
}

public extension Array {
    var randomColor : Element {
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}

public extension Date {
    
    func weekdayDiffence() -> Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday ?? 0
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }

    static func randomDates(days: Int, inYear year:Int) -> Date {
        
        let gregorian = Calendar(identifier: .gregorian)
        
        let randomDay = arc4random_uniform(UInt32(days))
        let randomMonth = arc4random_uniform(UInt32(12))
        let randomHour = arc4random_uniform(UInt32(23))
        let randomMinute = arc4random_uniform(UInt32(23))
        let randomSecond = arc4random_uniform(UInt32(23))
        
        let offsetComponents = NSDateComponents()
        offsetComponents.day = Int(randomDay)
        offsetComponents.month = Int(randomMonth)
        offsetComponents.year = Int(year)
        offsetComponents.hour = Int(randomHour)
        offsetComponents.minute = Int(randomMinute)
        offsetComponents.second = Int(randomSecond)
        
        let randomeDate = gregorian.date(from: offsetComponents as DateComponents)
        
        return randomeDate!
    }
    
    static func random() -> Date {
        let randomTime = TimeInterval(arc4random_uniform(UInt32.max))
        return Date(timeIntervalSince1970: randomTime)
    }
}
