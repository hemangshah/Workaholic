//
//  ViewController.swift
//  Workaholic
//
//  Created by Hemang Shah on 6/5/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var workView = WHWorkView()
    var yearsSegment = UISegmentedControl()
    
    var years = Array<String>()
    var contributions = Array<WHContribution>()
    
    let topMargin: Double = 80.0
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Sample Contributions
        self.createContributions()
        self.createYears()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //To set the correct height of WHWorkView, right now we have to add it in viewDidAppear to get the correct orientation of the view.
        if UIDevice.current.orientation.isValidInterfaceOrientation {
            let height = getWorkViewHeightAsPerTheOrientation()
            let margin: Double = 20.0
            let width: Double = Double(UIScreen.main.bounds.size.width) - (margin * 2.0)
            
            self.workView = WHWorkView.init(frame: CGRect.init(x: margin, y: topMargin, width: width, height: height))
            self.workView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
            self.view.addSubview(self.workView)
            //Please set any properties before calling workView.setup().
            self.workView.reload(withYear: Int(years.first!)!, withContributions: contributions)
            self.printSampleDataForYear(year: Int(years.first!)!)
            
            //Detect Taps on Work Logs
            self.workView.onWorkLogTapCompletion = { (whDate) in
                print("\(String(describing: whDate.day!)) \(String(describing: whDate.month!)) \(String(describing: whDate.year!)) [dd MM yyyy]")
                print(whDate.date!)
            }
            
            self.setupYearSegment(withMargin: margin, width: width)
        }
    }
    
    //MARK: Create Years
    fileprivate func createYears() {
        for year in 2008...2017 {
            self.years.append(String(year))
        }
        self.years.reverse()
    }
    
    //MARK: Setup Year UISegmentControl
    fileprivate func setupYearSegment(withMargin margin: Double, width: Double) {
        self.yearsSegment = UISegmentedControl(items: years)
        self.yearsSegment.frame = CGRect.init(x: margin, y: Double(workView.frame.origin.y) + workView.height() + topMargin/2.0, width: width, height: 30.0)
        self.yearsSegment.selectedSegmentIndex = 0
        self.yearsSegment.tintColor = UIColor.black
        self.yearsSegment.addTarget(self, action: #selector(self.actionYearsFilterApply), for: UIControlEvents.valueChanged)
        self.yearsSegment.autoresizingMask = [.flexibleWidth, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        self.view.addSubview(yearsSegment)
    }
    
    //MARK: Sample WHContributions Objects
    fileprivate func createContributions() -> Void {
        self.contributions.removeAll()
        self.contributions.append(WHContribution.init(Date: Date.randomDates(days: 1, inYear: 2017), WorkPercentage: .twentyFive))
        self.contributions.append(WHContribution.init(Date: Date.randomDates(days: 2, inYear: 2017), WorkPercentage: .fifty))
        self.contributions.append(WHContribution.init(Date: Date.randomDates(days: 3, inYear: 2017), WorkPercentage: .twentyFive))
        self.contributions.append(WHContribution.init(Date: Date.randomDates(days: 4, inYear: 2017), WorkPercentage: .fifty))
        self.contributions.append(WHContribution.init(Date: Date.randomDates(days: 5, inYear: 2017), WorkPercentage: .twentyFive))
        self.contributions.append(WHContribution.init(Date: Date.randomDates(days: 6, inYear: 2016), WorkPercentage: .seventyFive))
        self.contributions.append(WHContribution.init(Date: Date.randomDates(days: 7, inYear: 2015), WorkPercentage: .hundread))
        self.contributions.append(WHContribution.init(Date: Date.randomDates(days: 8, inYear: 2014), WorkPercentage: .seventyFive))
        self.contributions.append(WHContribution.init(Date: Date.randomDates(days: 9, inYear: 2013), WorkPercentage: .hundread))
        self.contributions.append(WHContribution.init(Date: Date.randomDates(days: 10, inYear: 2012), WorkPercentage: .zero))
    }
    
    //MARK: Segnement Target
    @objc fileprivate func actionYearsFilterApply(segment: UISegmentedControl) -> Void {
        let yearString = years[segment.selectedSegmentIndex]
        self.workView.reload(withYear: Int(yearString)!, withContributions: self.contributions)
        self.printSampleDataForYear(year: Int(yearString)!)
    }
    
    //MARK: Print Sample Data
    fileprivate func printSampleDataForYear(year: Int) -> Void {
        print("--------------- Sample Data for Year: \(year) ---------------")
        let results = self.contributions.filter { $0.date.compare(.isSameYear(as: Date(year: year, month: 1, day: 1))) }
        if !results.isEmpty {
            for contribution in results {
                print("\nDate: \(contribution.date) | percentageOfWork: \(contribution.percentageOfWork)")
            }
        } else {
            print("\n No Sample Data Available.")
        }
        print("----------------------------------------------------------------------------------\n")
    }
    
    //MARK: Rotation Handler
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            let orient = newCollection.verticalSizeClass
            switch orient {
            case .compact:
                //Lanscape
                self.correctHeightForWorkView(withHeight: 140.0)
            default:
                //Portrait
                self.correctHeightForWorkView(withHeight: 85.0)
            }
        }, completion: { _ in
            //Rotation completed
            self.correctYForYearsSegment()
            self.workView.reload(withYear: Int(self.years.first!)!, withContributions: self.contributions)
        })
        super.willTransition(to: newCollection, with: coordinator)
    }
    
    fileprivate func correctYForYearsSegment() -> Void {
        var currentFrame = yearsSegment.frame
        currentFrame.origin.y = CGFloat(Double(workView.frame.origin.y) + workView.height() + topMargin/2.0)
        self.yearsSegment.frame = currentFrame
    }
    
    fileprivate func correctHeightForWorkView(withHeight height: Double) -> Void {
        var currentFrame = workView.frame
        currentFrame.size.height = CGFloat(height)
        self.workView.frame = currentFrame
    }
    
    fileprivate func getWorkViewHeightAsPerTheOrientation() -> Double {
        if UIDevice.current.orientation.isValidInterfaceOrientation {
            if UIDevice.current.orientation.isLandscape {
                return 140.0
            } else {
                return 85.0
            }
        }
        return 0.0
    }
}
