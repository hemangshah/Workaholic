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
    
    var yearsArray = Array<String>()
    var arrayContributions = Array<WHContribution>()
    
    let topMargin: Double = 80.0
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Sample Contributions
        createContributions()
        
        //Create Years Array
        for year in 2008...2017 {
            yearsArray.append(String(year))
        }
        yearsArray.reverse()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        //To set the correct height of WHWorkView, right now we have to add it in viewDidAppear to get the correct orientation of the view.
        if UIDevice.current.orientation.isValidInterfaceOrientation {
            let height = getHeightBasedOnOrientation()
            let marging:Double = 20.0
            let width:Double = Double(UIScreen.main.bounds.size.width) - (marging * 2.0)
            
            workView = WHWorkView.init(frame: CGRect.init(x: marging, y: topMargin, width: width, height: height))
            workView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
            self.view.addSubview(workView)
            workView.setup(withYear: Int(yearsArray.first!)!, withContributions: arrayContributions)
            printSampleDataForYear(year: Int(yearsArray.first!)!)
            
            //Detect Taps on Work Logs
            workView.onWorkLogTappedCompletion = { (whDate) in
                print("\(String(describing: whDate.day!)) \(String(describing: whDate.month!)) \(String(describing: whDate.year!)) [dd MM yyyy]")
                print(whDate.date!)
            }
            
            yearsSegment = UISegmentedControl(items: yearsArray)
            yearsSegment.frame = CGRect.init(x: marging, y: Double(workView.frame.origin.y) + workView.height() + topMargin/2.0, width: width, height: 30.0)
            yearsSegment.selectedSegmentIndex = 0
            yearsSegment.tintColor = UIColor.black
            yearsSegment.addTarget(self, action: #selector(self.yearsfilterApply), for: UIControlEvents.valueChanged)
            yearsSegment.autoresizingMask = [.flexibleWidth, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
            self.view.addSubview(yearsSegment)
        }
    }
    
    //MARK: Sample WHContributions Objects
    func createContributions() -> Void {
        arrayContributions.removeAll()
        arrayContributions.append(WHContribution.init(Date: Date.randomDates(days: 1, inYear: 2017), WorkPercentage: .twentyFive))
        arrayContributions.append(WHContribution.init(Date: Date.randomDates(days: 2, inYear: 2017), WorkPercentage: .fifty))
        arrayContributions.append(WHContribution.init(Date: Date.randomDates(days: 3, inYear: 2017), WorkPercentage: .twentyFive))
        arrayContributions.append(WHContribution.init(Date: Date.randomDates(days: 4, inYear: 2017), WorkPercentage: .fifty))
        arrayContributions.append(WHContribution.init(Date: Date.randomDates(days: 5, inYear: 2017), WorkPercentage: .twentyFive))
        arrayContributions.append(WHContribution.init(Date: Date.randomDates(days: 6, inYear: 2016), WorkPercentage: .seventyFive))
        arrayContributions.append(WHContribution.init(Date: Date.randomDates(days: 7, inYear: 2015), WorkPercentage: .hundread))
        arrayContributions.append(WHContribution.init(Date: Date.randomDates(days: 8, inYear: 2014), WorkPercentage: .seventyFive))
        arrayContributions.append(WHContribution.init(Date: Date.randomDates(days: 9, inYear: 2013), WorkPercentage: .hundread))
        arrayContributions.append(WHContribution.init(Date: Date.randomDates(days: 10, inYear: 2012), WorkPercentage: .zero))
    }
    
    //MARK: Print Sample Data
    func printSampleDataForYear(year:Int) -> Void {
        print("--------------- Sample Data for Year: \(year) ---------------")
        let results = arrayContributions.filter { $0.whcDate.compare(.isSameYear(as: Date(year: year, month: 1, day: 1))) }
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
        workView.setup(withYear: Int(yearString)!, withContributions: arrayContributions)
        printSampleDataForYear(year: Int(yearString)!)
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
            self.workView.setup(withYear: Int(self.yearsArray.first!)!, withContributions: self.arrayContributions)
        })
        super.willTransition(to: newCollection, with: coordinator)
    }
    
    func correctYForYearsSegment() -> Void {
        var currentFrame = yearsSegment.frame
        currentFrame.origin.y = CGFloat(Double(workView.frame.origin.y) + workView.height() + topMargin/2.0)
        yearsSegment.frame = currentFrame
    }
    
    func correctHeightForWorkView(withHeight height:Double) -> Void {
        var currentFrame = workView.frame
        currentFrame.size.height = CGFloat(height)
        workView.frame = currentFrame
    }
    
    func getHeightBasedOnOrientation() -> Double {
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
