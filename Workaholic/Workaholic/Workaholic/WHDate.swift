//
//  WHDate.swift
//  Workaholic
//
//  Created by Hemang Shah on 6/10/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import Foundation

final public class WHDate {
    public var date: Date? = nil
    public var day: Int? = 0
    public var month: Int? = 0
    public var year: Int? = 0
    
    public init (Date date: Date, Day day: Int, Month month: Int, Year year: Int) {
        self.date = date
        self.day = day
        self.month = month
        self.year = year
    }
}
