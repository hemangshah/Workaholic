//
//  WHContributions.swift
//  Workaholic
//
//  Created by Hemang Shah on 6/7/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import Foundation

public enum WorkCompletedPercentage {
    case zero, twentyFive, fifty, seventyFive, hundread
}

/**
 You can always subclass WHContributions for your own needs.
*/
public class WHContribution {
    
    ///Set the contribution date.
    public var date = Date()
    
    ///Based on your requirements and calculations you set the total work contributions by a user on a particular date. Default: zero percentage
    public var percentageOfWork: WorkCompletedPercentage = .zero
    
    ///Init.
    public init(date: Date, workPercentage: WorkCompletedPercentage) {
        self.date = date
        self.percentageOfWork = workPercentage
    }
}
