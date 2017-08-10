//
//  WHContributions.swift
//  Workaholic
//
//  Created by Hemang Shah on 6/7/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import Foundation

public enum WHWorkPecentage {
    case zero, twentyFive, fifty, seventyFive, hundread
}

/**
 You can always subclass WHContributions for your own needs.
 */
public class WHContributions {
    public var whcDate:Date = Date()
    public var whcWorkPercentage:WHWorkPecentage = .zero
    
    public init (Date whcDate:Date, WorkPercentage whcWorkPercentage:WHWorkPecentage) {
        self.whcDate = whcDate
        self.whcWorkPercentage = whcWorkPercentage
    }
}
