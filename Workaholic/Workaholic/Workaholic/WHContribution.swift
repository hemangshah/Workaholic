//
//  WHContributions.swift
//  Workaholic
//
//  Created by Hemang Shah on 6/7/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import Foundation

///Work completed percentage divided in 5 categories to showcase user's work contribution percentage.
public enum WorkCompletedPercentage {
    case zero, twentyFive, fifty, seventyFive, hundread
}

///You can always subclass WHContributions for your own needs.
public struct WHContribution {
    ///Set the contribution date.
    public var date = Date()
    ///Set work completed percentage as per a user contribution on a particular date. Default: zero (No contribution).
    public var percentageOfWork: WorkCompletedPercentage = .zero
}
