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
    
    private let year = Date.init().year
    private lazy var contributions: [WHContribution] = {
        var array = [WHContribution]()
        array.append(WHContribution(date: Date.randomDates(days: 1, inYear: year), workPercentage: .twentyFive))
        array.append(WHContribution(date: Date.randomDates(days: 2, inYear: year), workPercentage: .fifty))
        array.append(WHContribution(date: Date.randomDates(days: 3, inYear: year), workPercentage: .twentyFive))
        array.append(WHContribution(date: Date.randomDates(days: 4, inYear: year), workPercentage: .fifty))
        array.append(WHContribution(date: Date.randomDates(days: 5, inYear: year), workPercentage: .twentyFive))
        array.append(WHContribution(date: Date.randomDates(days: 6, inYear: year), workPercentage: .seventyFive))
        array.append(WHContribution(date: Date.randomDates(days: 7, inYear: year), workPercentage: .hundread))
        array.append(WHContribution(date: Date.randomDates(days: 8, inYear: year), workPercentage: .seventyFive))
        array.append(WHContribution(date: Date.randomDates(days: 9, inYear: year), workPercentage: .hundread))
        array.append(WHContribution(date: Date.randomDates(days: 10, inYear: year), workPercentage: .zero))
        return array
    }()
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Always, reload workView in viewDidAppear.
        
        self.workView.reload(year: year, contributions: contributions)

        self.workView.onWorkLogDateTapCompletion = { (whDate, whContribution) in
            if let date = whDate?.date, let contribution = whContribution {
                print(String.init(describing: date) + " has contributions. Percentage: \(contribution.percentageOfWork)")
            } else {
                print("No contributions.")
            }
        }
        
    }
}
