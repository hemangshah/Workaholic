//
//  ViewController.swift
//  Workaholic
//
//  Created by Hemang Shah on 6/5/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import UIKit

public extension Date {
    /// SwiftRandom extension
    public static func randomDates(days: Int, inYear year:Int) -> Date {

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
    
    /// SwiftRandom extension
    public static func random() -> Date {
        let randomTime = TimeInterval(arc4random_uniform(UInt32.max))
        return Date(timeIntervalSince1970: randomTime)
    }
}

class ViewController: UIViewController {

    var yearsArray = Array<String>()
    var workView = WHWorkView()
    
    var sampleContributionsData = Array<WHContributions>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createSampleContributionsData()
        
        yearsArray = ["2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009", "2008"]
        
        let marging:Double = 20.0
        let topMargin:Double = 80.0
        let width:Double = Double(UIScreen.main.bounds.size.width) - (marging * 2.0)
        let height:Double = 140.0 //115.0
        workView = WHWorkView.init(frame: CGRect.init(x: marging, y: topMargin, width: width, height: height))
        workView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        self.view.addSubview(workView)
        workView.setup(withYear: Int(yearsArray.first!)!, withContributions: sampleContributionsData)
        printSampleDataForYear(year: Int(yearsArray.first!)!)

        let yearsSegment = UISegmentedControl(items: yearsArray)
        yearsSegment.frame = CGRect.init(x: marging, y: Double(workView.frame.origin.y) + workView.getMyHeight() + topMargin/2.0, width: width, height: 30.0)
        yearsSegment.selectedSegmentIndex = 0
        yearsSegment.tintColor = UIColor.black
        yearsSegment.addTarget(self, action: #selector(self.yearsfilterApply), for: UIControlEvents.valueChanged)
        self.view.addSubview(yearsSegment)
    }
    
    //MARK: Sample WHContributions Object
    
    func createSampleContributionsData() -> Void {
        sampleContributionsData.removeAll()
        sampleContributionsData.append(WHContributions.init(Date: Date.randomDates(days: 1, inYear: 2017), WorkPercentage: .twentyFive))
        sampleContributionsData.append(WHContributions.init(Date: Date.randomDates(days: 2, inYear: 2017), WorkPercentage: .fifty))
        sampleContributionsData.append(WHContributions.init(Date: Date.randomDates(days: 3, inYear: 2017), WorkPercentage: .twentyFive))
        sampleContributionsData.append(WHContributions.init(Date: Date.randomDates(days: 4, inYear: 2017), WorkPercentage: .fifty))
        sampleContributionsData.append(WHContributions.init(Date: Date.randomDates(days: 5, inYear: 2017), WorkPercentage: .twentyFive))
        sampleContributionsData.append(WHContributions.init(Date: Date.randomDates(days: 6, inYear: 2016), WorkPercentage: .seventyFive))
        sampleContributionsData.append(WHContributions.init(Date: Date.randomDates(days: 7, inYear: 2015), WorkPercentage: .hundread))
        sampleContributionsData.append(WHContributions.init(Date: Date.randomDates(days: 8, inYear: 2014), WorkPercentage: .seventyFive))
        sampleContributionsData.append(WHContributions.init(Date: Date.randomDates(days: 9, inYear: 2013), WorkPercentage: .hundread))
        sampleContributionsData.append(WHContributions.init(Date: Date.randomDates(days: 10, inYear: 2012), WorkPercentage: .zero))
    }
    
    //MARK: Print Sample Data
    func printSampleDataForYear(year:Int) -> Void {
        print("--------------- Sample Data for Year: \(year) ---------------")
        let results = sampleContributionsData.filter { $0.whcDate.compare(.isSameYear(as: Date(year: year, month: 1, day: 1))) }
        if !results.isEmpty {
            for contribution in results {
                print("\n\(contribution.whcDate)")
            }
        } else {
            print("\n No Sample Data Available.")
        }
        print("----------------------------------------------------------------------------------\n")
    }
    
    //MARK: Segnement Target
    @objc fileprivate func yearsfilterApply(segment:UISegmentedControl) -> Void {
        let yearString = yearsArray[segment.selectedSegmentIndex]
        workView.setup(withYear: Int(yearString)!, withContributions: sampleContributionsData)
        printSampleDataForYear(year: Int(yearString)!)
    }
}
