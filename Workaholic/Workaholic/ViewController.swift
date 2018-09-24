//
//  ViewController.swift
//  Workaholic
//
//  Created by Hemang Shah on 6/5/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var workView: WHWorkView!
    
    private lazy var contributions: [WHContribution] = {
        var array = [WHContribution]()
        array.append(WHContribution(date: Date.randomDate(inYear: 2018), percentageOfWork: .twentyFive))
        array.append(WHContribution(date: Date.randomDate(inYear: 2018), percentageOfWork: .fifty))
        array.append(WHContribution(date: Date.randomDate(inYear: 2018), percentageOfWork: .twentyFive))
        array.append(WHContribution(date: Date.randomDate(inYear: 2018), percentageOfWork: .fifty))
        array.append(WHContribution(date: Date.randomDate(inYear: 2018), percentageOfWork: .twentyFive))
        array.append(WHContribution(date: Date.randomDate(inYear: 2018), percentageOfWork: .seventyFive))
        array.append(WHContribution(date: Date.randomDate(inYear: 2018), percentageOfWork: .hundread))
        array.append(WHContribution(date: Date.randomDate(inYear: 2018), percentageOfWork: .seventyFive))
        array.append(WHContribution(date: Date.randomDate(inYear: 2018), percentageOfWork: .hundread))
        array.append(WHContribution(date: Date.randomDate(inYear: 2018), percentageOfWork: .zero))
        return array
    }()
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Always, reload workView in viewDidAppear.
        
        self.workView.reload(year: 2018, contributions: contributions)

        self.workView.onWorkLogDateTapCompletion = { (whDate, whContribution) in
            if let date = whDate?.date, let contribution = whContribution {
                print(String.init(describing: date) + " has contributions. Percentage: \(contribution.percentageOfWork)")
            } else {
                print("No contributions.")
            }
        }
        
    }
}

extension Date {
    static func randomDate(inYear year: Int) -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        let randomDay = arc4random_uniform(UInt32(25))
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
}
