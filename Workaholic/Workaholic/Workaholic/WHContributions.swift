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

public class WHContributions {
    public var whcID:String = ""
    public var whcTitle:String = ""
    public var whcDescription:String = ""
    public var whcDate:Date = Date()
    public var whcWorkPercentage:WHWorkPecentage = .zero
    
    public init (ID whcID:String, Title whcTitle:String, Description whcDescription:String, Date whcDate:Date, WorkPercentage whcWorkPercentage:WHWorkPecentage) {
        self.whcID = whcID
        self.whcTitle = whcTitle
        self.whcDescription = whcDescription
        self.whcDate = whcDate
        self.whcWorkPercentage = whcWorkPercentage
    }
}
