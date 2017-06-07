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
    public static func randomDates(days: Int) -> Date {
        let today = Date()
        let gregorian = Calendar(identifier: .gregorian)

        let r1 = arc4random_uniform(UInt32(days))
        let r2 = arc4random_uniform(UInt32(23))
        let r3 = arc4random_uniform(UInt32(23))
        let r4 = arc4random_uniform(UInt32(23))
        
        let offsetComponents = NSDateComponents()
        offsetComponents.day = Int(r1)
        offsetComponents.hour = Int(r2)
        offsetComponents.minute = Int(r3)
        offsetComponents.second = Int(r4)
        
        let rndDate1 = gregorian.date(byAdding: offsetComponents as DateComponents, to: today)
        return rndDate1!
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

        let yearsSegment = UISegmentedControl(items: yearsArray)
        yearsSegment.frame = CGRect.init(x: marging, y: Double(workView.frame.origin.y) + workView.getMyHeight() + topMargin/2.0, width: width, height: 30.0)
        yearsSegment.selectedSegmentIndex = 0
        yearsSegment.tintColor = UIColor.black
        yearsSegment.addTarget(self, action: #selector(self.yearsfilterApply), for: UIControlEvents.valueChanged)
        self.view.addSubview(yearsSegment)
    }
    
    //MARK: Sample WHContributions Object
    
    func createSampleContributionsData() -> Void {
        sampleContributionsData.append(WHContributions.init(ID: "1", Title: "This is a contribution title.", Description: "This is a contribution description.", Date: Date.randomDates(days: 5), WorkPercentage: .seventyFive))
        sampleContributionsData.append(WHContributions.init(ID: "2", Title: "This is a contribution title.", Description: "This is a contribution description.", Date: Date.randomDates(days: 15), WorkPercentage: .twentyFive))
        sampleContributionsData.append(WHContributions.init(ID: "3", Title: "This is a contribution title.", Description: "This is a contribution description.", Date: Date.randomDates(days: 25), WorkPercentage: .zero))
        sampleContributionsData.append(WHContributions.init(ID: "4", Title: "This is a contribution title.", Description: "This is a contribution description.", Date: Date.randomDates(days: 20), WorkPercentage: .hundread))
        sampleContributionsData.append(WHContributions.init(ID: "5", Title: "This is a contribution title.", Description: "This is a contribution description.", Date: Date.randomDates(days: 30), WorkPercentage: .fifty))
        
        print("---------------SAMPLE DATA---------------")
        for contribution in sampleContributionsData {
            print("Date:\(contribution.whcDate)")
        }
        print("-----------------------------------------")
    }
    
    //MARK: Segnement Target
    @objc fileprivate func yearsfilterApply(segment:UISegmentedControl) -> Void {
        let yearString = yearsArray[segment.selectedSegmentIndex]
        workView.setup(withYear: Int(yearString)!, withContributions: sampleContributionsData)
    }
}
