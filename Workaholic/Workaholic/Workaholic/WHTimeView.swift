//
//  WHTimeView.swift
//  Workaholic
//
//  Created by Hemang Shah on 6/5/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import UIKit

class WHTimeView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.addTimeLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addTimeLabels() -> Void {
        let totalMonths:CGFloat = 12
        
        let monthLabelWidth:CGFloat = self.getMyWidth()/totalMonths
        let monthLabelHeight:CGFloat = self.getMyHeight()
        
        var monthLabelPointX:CGFloat = 0.0
        let monthLabelPointY:CGFloat = 0.0
        
        let monthLabelColor = UIColor.init(red: 118.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        
        let convertTotalMonths:NSInteger = NSInteger(totalMonths)
        
        let nowYear = Date.init()
        let nowYearString = nowYear.toString(format: .isoYear)
        var dateArray = Array<String>()
        var realDateArray = Array<Date>()
        dateArray.append("01-01-\(nowYearString)")
        dateArray.append("01-02-\(nowYearString)")
        dateArray.append("01-03-\(nowYearString)")
        dateArray.append("01-04-\(nowYearString)")
        dateArray.append("01-05-\(nowYearString)")
        dateArray.append("01-06-\(nowYearString)")
        dateArray.append("01-07-\(nowYearString)")
        dateArray.append("01-08-\(nowYearString)")
        dateArray.append("01-09-\(nowYearString)")
        dateArray.append("01-10-\(nowYearString)")
        dateArray.append("01-11-\(nowYearString)")
        dateArray.append("01-12-\(nowYearString)")

        for index in 0..<dateArray.count {
            let date = Date.init(fromString: dateArray[index], format: .custom("dd-MM-yyyy"))
            realDateArray.append(date!)
            print(date!.toString(style: .shortMonth) as Any)
        }
        
        for monthIndex in 0..<convertTotalMonths {
            let monthLabel = UILabel.init(frame: CGRect.init(x: monthLabelPointX, y: monthLabelPointY, width: monthLabelWidth, height: monthLabelHeight))
            let date = realDateArray[monthIndex]
            monthLabel.text = date.toString(style: .shortMonth)
            monthLabel.font = UIFont.systemFont(ofSize: 10.0)
            monthLabel.textColor = monthLabelColor
            monthLabel.backgroundColor = UIColor.clear
            monthLabel.textAlignment = .center
            self.addSubview(monthLabel)
            monthLabelPointX = monthLabelPointX + monthLabel.frame.size.width
        }
    }
}
