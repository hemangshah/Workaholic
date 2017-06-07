//
//  ViewController.swift
//  Workaholic
//
//  Created by Hemang Shah on 6/5/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var yearsArray = Array<String>()
    var workView = WHWorkView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        yearsArray = ["2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009", "2008"]
        
        let marging:Double = 20.0
        let topMargin:Double = 80.0
        let width:Double = Double(UIScreen.main.bounds.size.width) - (marging * 2.0)
        let height:Double = 140.0 //115.0
        workView = WHWorkView.init(frame: CGRect.init(x: marging, y: topMargin, width: width, height: height))
        workView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        self.view.addSubview(workView)
        //workView.setup(withYear: Int(yearsArray.first!)!)
        workView.setup(withYear: Int(yearsArray[1])!)

        let yearsSegment = UISegmentedControl(items: yearsArray)
        yearsSegment.frame = CGRect.init(x: marging, y: Double(workView.frame.origin.y) + workView.getMyHeight() + topMargin/2.0, width: width, height: 30.0)
        yearsSegment.selectedSegmentIndex = 0
        yearsSegment.tintColor = UIColor.black
        yearsSegment.addTarget(self, action: #selector(self.yearsfilterApply), for: UIControlEvents.valueChanged)
        self.view.addSubview(yearsSegment)
        yearsSegment.selectedSegmentIndex = 1
    }
    
    //MARK: Segnement Target
    @objc fileprivate func yearsfilterApply(segment:UISegmentedControl) -> Void {
        let yearString = yearsArray[segment.selectedSegmentIndex]
        workView.setup(withYear: Int(yearString)!)
    }
}
