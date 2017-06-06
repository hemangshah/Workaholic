//
//  WHWorkView.swift
//  Workaholic
//
//  Created by Hemang Shah on 6/5/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import UIKit

fileprivate extension Array {
    var randomColor : Element {
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
}

fileprivate let valueStandardWidthForHelperView:CGFloat = 65.0

fileprivate let valueStandardHeightForTimeView:CGFloat = 25.0
fileprivate let valueStandardHeightForHelperView:CGFloat = 25.0

fileprivate let zeroPercentageLoggedColor = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
fileprivate let twenty5percentageLoggedColor = UIColor.init(red: 197.0/255.0, green: 229.0/255.0, blue: 134.0/255.0, alpha: 1.0)
fileprivate let fiftyPercentageLoggedColor = UIColor.init(red: 120.0/255.0, green: 202.0/255.0, blue: 107.0/255.0, alpha: 1.0)
fileprivate let seventy5percentageLoggedColor = UIColor.init(red: 25.0/255.0, green: 155.0/255.0, blue: 53.0/255.0, alpha: 1.0)
fileprivate let hundreadPercentageLoggedColor = UIColor.init(red: 20.0/255.0, green: 98.0/255.0, blue: 36.0/255.0, alpha: 1.0)

class WHWorkView : UIView {
    
    fileprivate var logColorsArray = Array<UIColor>()
    
    //MARK: Init with Frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Add Time View (Months)
    fileprivate func addTimeView(withInitialMargin margin:CGFloat) -> Void {
        let rect = CGRect.init(x: margin, y: 0.0, width: self.getMyWidth() - margin, height: valueStandardHeightForTimeView)
        let timeView = WHTimeView.init(frame: rect)
        self.addSubview(timeView)
    }
    
    //MARK: Add Workaholic View
    fileprivate func addWorkLogs() -> Void {
        
        let initialMargin:CGFloat = 35.0
        let margin:CGFloat = 2.0
        let numberOfLogsInColumn = 7
        
        var logBoxPointX = initialMargin + margin
        var logBoxPointY = valueStandardHeightForTimeView + margin
        
        //Add Month View
        self.addTimeView(withInitialMargin: logBoxPointX)
        
        //Start - Calculating Box Sizes.
        let startMonth:NSInteger = 1
        let totalMonths:NSInteger = 12
        
        var totalColumns = Array<NSInteger>()
        
        let nowYear = Date.init()
        let nowYearString = nowYear.toString(format: .isoYear)
        
        for monthIndex in startMonth...totalMonths {
            let dateOfMonth = Date.init(fromString: "01-\(monthIndex)-\(2016)", format: .custom("dd-M-yyyy"))
            let numberOfDaysInMonth = NSInteger(dateOfMonth!.numberOfDaysInMonth())
            totalColumns.append(numberOfDaysInMonth)
        }
        //End - Calculating Box Sizes.
        
        let numberOfColumnsInEachRow:CGFloat = CGFloat(totalColumns.reduce(0, +)/numberOfLogsInColumn)
        
        let logBoxWidthAndHeight:CGFloat = ((self.getMyWidth() - ((numberOfColumnsInEachRow * margin) + logBoxPointX))/numberOfColumnsInEachRow)
        let logBoxSize = CGSize.init(width: logBoxWidthAndHeight, height: logBoxWidthAndHeight)
        
        //Start – Add Log Box
        
        var rowIndex = 1
        var logsInColumnCounter = 1

        for monthIndex in startMonth...totalMonths {
            
            let dateOfMonth = Date.init(fromString: "01-\(monthIndex)-\(nowYearString)", format: .custom("dd-M-yyyy"))
            let numberOfDaysInMonth = dateOfMonth!.numberOfDaysInMonth()
            print("\((dateOfMonth!.toString(style: .shortMonth))) has \(numberOfDaysInMonth) days.")

            //Start – Internal Loop
            for columnIndex in 1...numberOfDaysInMonth {
                let workLabel = UILabel.init(frame: CGRect.init(x: logBoxPointX, y: logBoxPointY, width: logBoxSize.width, height: logBoxSize.height))
                workLabel.backgroundColor = ((rowIndex % 3 == 0 && columnIndex % 5 == 0) ? logColorsArray.randomColor : zeroPercentageLoggedColor)
                workLabel.text = "\(columnIndex)"
                workLabel.textAlignment = .center
                workLabel.font = UIFont.systemFont(ofSize: 3)
                self.addSubview(workLabel)
                
                if logsInColumnCounter % numberOfLogsInColumn == 0 {
                    logBoxPointX = logBoxPointX + logBoxSize.width + margin
                    logBoxPointY = valueStandardHeightForTimeView + margin
                    logsInColumnCounter = 1
                } else {
                    logBoxPointY = logBoxPointY + logBoxSize.height + margin
                    rowIndex = rowIndex + 1
                    logsInColumnCounter = logsInColumnCounter + 1
                }

                //Start - Days Label
                //Labels: Mon / Wed / Fri
                if rowIndex % 2 == 0 {
                    let daysLabel = UILabel.init(frame: CGRect.init(x: margin, y: logBoxPointY, width: initialMargin - (margin * 2.0), height: logBoxSize.height))
                    
                    if rowIndex == 2 {
                        daysLabel.text = "Mon"
                        
                    } else if rowIndex == 4 {
                        daysLabel.text = "Wed"
                        
                    } else if rowIndex == 6 {
                        daysLabel.text = "Fri"
                    }
                    
                    daysLabel.backgroundColor = UIColor.clear
                    daysLabel.textAlignment = .right
                    daysLabel.textColor = UIColor.init(red: 118.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                    daysLabel.font = UIFont.systemFont(ofSize: 8.0)
                    self.addSubview(daysLabel)
                }
                //End - Days Label
                
            }
            //End – Internal Loop
            
        }
        
        //End – Add Log Box
        
        self.addHelper(withLogBoxPointY: logBoxPointY + (CGFloat(numberOfLogsInColumn) * logBoxSize.height), withLogBoxSize: logBoxSize)
    }
    
    //MARK: Add Logging Colors
    fileprivate func addLogColors() -> Void {
        logColorsArray.append(zeroPercentageLoggedColor)
        logColorsArray.append(twenty5percentageLoggedColor)
        logColorsArray.append(fiftyPercentageLoggedColor)
        logColorsArray.append(seventy5percentageLoggedColor)
        logColorsArray.append(hundreadPercentageLoggedColor)
    }
    
    //MARK: Add Helper UI
    fileprivate func addHelper(withLogBoxPointY storedLogBoxPointY:CGFloat, withLogBoxSize storedLogBoxSize:CGSize) -> Void {
        let margin:CGFloat = 2.0
        let numberOfColors = logColorsArray.count
        
        let remainingDifference = (self.getMyHeight() - storedLogBoxPointY)
        let helperViewHeight = (remainingDifference > valueStandardHeightForHelperView) ? valueStandardHeightForHelperView : remainingDifference
        
        //Helper View
        let helperViewSize = CGSize.init(width: valueStandardWidthForHelperView + (CGFloat(numberOfColors) * storedLogBoxSize.width), height: helperViewHeight)
        let helperView = UIView.init(frame: CGRect.init(origin: CGPoint.init(x: self.getMyWidth() - helperViewSize.width, y: storedLogBoxPointY), size: helperViewSize))
        helperView.backgroundColor = UIColor.clear
        self.addSubview(helperView)

        //Label: Less
        let helpLabelLess = UILabel.init(frame: CGRect.init(x: 0.0, y: 0.0 + margin, width: 25.0, height: 10.0))
        helpLabelLess.backgroundColor = UIColor.clear
        helpLabelLess.text = "Less"
        helpLabelLess.font = UIFont.systemFont(ofSize: 8.0)
        helpLabelLess.textColor = UIColor.init(red: 118.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        helperView.addSubview(helpLabelLess)
        helpLabelLess.center = CGPoint.init(x: helpLabelLess.center.x, y: helperView.frame.size.height/2.0)
        
        //Log Boxes Progress
        var helperBoxPointX:CGFloat = helpLabelLess.frame.size.width + margin
        
        for index in 0..<numberOfColors {
            let helpLogLabel = UILabel.init(frame: CGRect.init(x: helperBoxPointX, y: 0.0, width: storedLogBoxSize.width, height: storedLogBoxSize.height))
            helpLogLabel.backgroundColor = logColorsArray[index]
            helperView.addSubview(helpLogLabel)
            helperBoxPointX = helperBoxPointX + helpLogLabel.frame.size.width + margin
            helpLogLabel.center = CGPoint.init(x: helpLogLabel.center.x, y: helperView.frame.size.height/2.0)
        }
        
        //Label: More
        let helpLabelMore = UILabel.init(frame: CGRect.init(x: helperBoxPointX, y: 0.0, width: 25.0, height: 10.0))
        helpLabelMore.backgroundColor = UIColor.clear
        helpLabelMore.textAlignment = .right
        helpLabelMore.text = "More"
        helpLabelMore.font = UIFont.systemFont(ofSize: 8.0)
        helpLabelMore.textColor = UIColor.init(red: 118.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        helperView.addSubview(helpLabelMore)
        helpLabelMore.center = CGPoint.init(x: helpLabelMore.center.x, y: helperView.frame.size.height/2.0)
    }
    
    //MARK: Setup Everything!
    public func setup() -> Void {
        self.addLogColors()
        self.addWorkLogs()
    }
}
