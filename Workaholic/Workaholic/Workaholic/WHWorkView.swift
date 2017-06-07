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

fileprivate extension Date {
    func weekdayDiffence() -> Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday ?? 0
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

fileprivate let valueStandardWidthForHelperView:Double = 65.0

fileprivate let valueStandardHeightForTimeView:Double = 25.0
fileprivate let valueStandardHeightForHelperView:Double = 25.0

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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Add Workaholic View
    fileprivate func addWorkLogs(forYear logsForYear:Int) -> Void {
        
        let nowYear = Date(year: logsForYear, month: 1, day: 1)
        let nowYearString = nowYear.toString(format: .isoYear)
        
        let initialMargin:Double = 35.0
        let margin:Double = 2.0
        let numberOfLogsInColumn = nowYear.numberOfDaysInWeek()
        
        var logBoxPointX:Double = Double(initialMargin + margin)
        var logBoxPointY:Double = valueStandardHeightForTimeView + margin
        
        //Start - Calculating Box Sizes.
        let totalMonths:NSInteger = nowYear.numberOfMonthsInYear()

        let numberOfColumnsInEachRow:Double = Double(nowYear.numberOfDaysInYear()/numberOfLogsInColumn)

        let logBoxWidthAndHeight:Double = floor(((self.getMyWidth() - ((numberOfColumnsInEachRow * margin) + logBoxPointX))/numberOfColumnsInEachRow))
        
        let logBoxSize = CGSize.init(width: Double(logBoxWidthAndHeight), height: Double(logBoxWidthAndHeight))
 
        //------------------------------------------------------------------------
        //Start - Days Label
        //Labels: Mon / Wed / Fri
        
        //Update logBoxPointY for Days Label
        logBoxPointY = logBoxPointY + Double(logBoxSize.height) + margin
        
        for rowIndex in 1...3 {
            let daysLabel = UILabel.init(frame: CGRect.init(x: margin, y: logBoxPointY, width: initialMargin - (margin * 2.0), height: Double(logBoxSize.height)))
            
            if rowIndex == 1 {
                daysLabel.text = "Mon"
                
            } else if rowIndex == 2 {
                daysLabel.text = "Wed"
                
            } else if rowIndex == 3 {
                daysLabel.text = "Fri"
            }
            
            daysLabel.backgroundColor = UIColor.clear
            daysLabel.textAlignment = .right
            daysLabel.textColor = UIColor.init(red: 118.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0)
            daysLabel.font = UIFont.systemFont(ofSize: 8.0)
            self.addSubview(daysLabel)
            logBoxPointY = logBoxPointY + Double(logBoxSize.height * 2.0) + (margin * 2.0)
        }
        
        //Reset logBoxPointY
        logBoxPointY = valueStandardHeightForTimeView + margin

        //End - Days Label
        //------------------------------------------------------------------------

        //------------------------------------------------------------------------
        //Start – Add Log Boxes
        
        var logsInColumnCounter = 1
        var previousMonth = 0
        
        for monthIndex in 0...totalMonths {
            
            //monthIndex = 0 because we have to show the days from previous year.
            
            if monthIndex == 0 {

                var remainingDays = (nowYear.weekdayDiffence() - 1)
                if remainingDays <= 0 {
                    remainingDays = 7
                }
                let previousYearDate = nowYear - remainingDays.days

                //------------------------------------------------------------------------
                //Start – Internal Loop
                for columnIndex in previousYearDate!.day...previousYearDate!.numberOfDaysInMonth() {
                    let workLabel = UILabel.init(frame: CGRect.init(x: Double(logBoxPointX), y: Double(logBoxPointY), width: Double(logBoxSize.width), height: Double(logBoxSize.height)))
                    workLabel.backgroundColor = zeroPercentageLoggedColor
//                    workLabel.text = "\(columnIndex)"
//                    workLabel.textAlignment = .center
//                    workLabel.font = UIFont.systemFont(ofSize: 3)
                    self.addSubview(workLabel)
                    
                    if logsInColumnCounter % numberOfLogsInColumn == 0 {
                        logBoxPointX = logBoxPointX + Double(logBoxSize.width) + margin
                        logBoxPointY = valueStandardHeightForTimeView + margin
                        logsInColumnCounter = 1
                    } else {
                        logBoxPointY = logBoxPointY + Double(logBoxSize.height) + margin
                        logsInColumnCounter = logsInColumnCounter + 1
                    }
                }
                //End – Internal Loop
                //------------------------------------------------------------------------
                
            } else {
                
                let dateOfMonth = Date.init(fromString: "01-\(monthIndex)-\(nowYearString)", format: .custom("dd-M-yyyy"))
                let numberOfDaysInMonth = dateOfMonth!.numberOfDaysInMonth()
                
                //------------------------------------------------------------------------
                //Start – Internal Loop
                for columnIndex in 1...numberOfDaysInMonth {
                    let workLabel = UILabel.init(frame: CGRect.init(x: logBoxPointX, y: logBoxPointY, width: Double(logBoxSize.width), height: Double(logBoxSize.height)))
                    workLabel.backgroundColor = logColorsArray.randomColor
//                    workLabel.text = "\(columnIndex)"
//                    workLabel.textAlignment = .center
//                    workLabel.font = UIFont.systemFont(ofSize: 3)
                    self.addSubview(workLabel)
                    
                    if logsInColumnCounter % numberOfLogsInColumn == 0 {
                        logBoxPointX = logBoxPointX + Double(logBoxSize.width) + margin
                        logBoxPointY = valueStandardHeightForTimeView + margin
                        logsInColumnCounter = 1
                    } else {
                        logBoxPointY = logBoxPointY + Double(logBoxSize.height) + margin
                        logsInColumnCounter = logsInColumnCounter + 1
                    }
                    
                    //------------------------------------------------------------------------
                    //Start - Months Label
                    //Labels: Jan, Feb, Mar
                    
                    if previousMonth != monthIndex {
                        previousMonth = monthIndex
                        
                        let monthLabel = UILabel.init(frame: CGRect.init(x: logBoxPointX, y: 0.0, width: (Double((numberOfDaysInMonth/numberOfLogsInColumn)) * Double(logBoxSize.width)) + margin, height: valueStandardHeightForTimeView))
                        
                        if monthIndex == 1 {
                            monthLabel.text = "Jan"
                            
                        } else if monthIndex == 2 {
                            monthLabel.text = "Feb"
                            
                        } else if monthIndex == 3 {
                            monthLabel.text = "Mar"
                            
                        } else if monthIndex == 4 {
                            monthLabel.text = "Apr"
                            
                        } else if monthIndex == 5 {
                            monthLabel.text = "May"
                            
                        } else if monthIndex == 6 {
                            monthLabel.text = "Jun"
                            
                        } else if monthIndex == 7 {
                            monthLabel.text = "Jul"
                            
                        } else if monthIndex == 8 {
                            monthLabel.text = "Aug"
                            
                        } else if monthIndex == 9 {
                            monthLabel.text = "Sep"
                            
                        } else if monthIndex == 10 {
                            monthLabel.text = "Oct"
                            
                        } else if monthIndex == 11 {
                            monthLabel.text = "Nov"
                            
                        } else if monthIndex == 12 {
                            monthLabel.text = "Dec"
                            
                        }

                        monthLabel.font = UIFont.systemFont(ofSize: 10.0)
                        monthLabel.textColor = UIColor.init(red: 118.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0)
                        monthLabel.backgroundColor = UIColor.clear
                        monthLabel.textAlignment = .center
                        self.addSubview(monthLabel)
                    }
                    //End - Months Label
                    //------------------------------------------------------------------------

                }
                //End – Internal Loop
                //------------------------------------------------------------------------
            }
        }
        
        //End – Add Log Boxes
        //------------------------------------------------------------------------
        
        self.addHelper(withLogBoxPoints: CGPoint.init(x: logBoxPointX, y: Double(Double(numberOfLogsInColumn) * Double(logBoxSize.height)) + valueStandardHeightForTimeView + (margin * Double(numberOfLogsInColumn)) + margin), withLogBoxSize: logBoxSize)
    }
    
    //MARK: Add Logging Colors
    fileprivate func addLogColors() -> Void {
        logColorsArray.removeAll()
        logColorsArray.append(zeroPercentageLoggedColor)
        logColorsArray.append(twenty5percentageLoggedColor)
        logColorsArray.append(fiftyPercentageLoggedColor)
        logColorsArray.append(seventy5percentageLoggedColor)
        logColorsArray.append(hundreadPercentageLoggedColor)
    }
    
    //MARK: Add Helper UI
    fileprivate func addHelper(withLogBoxPoints storedLogBoxPoint:CGPoint, withLogBoxSize storedLogBoxSize:CGSize) -> Void {
        let margin:Double = 2.0
        let numberOfColors = logColorsArray.count
        
        let remainingDifference = (self.getMyHeight() - Double(storedLogBoxPoint.y))
        let helperViewHeight = (remainingDifference > valueStandardHeightForHelperView) ? valueStandardHeightForHelperView : remainingDifference
        
        //Helper View
        let helperViewSize = CGSize.init(width: valueStandardWidthForHelperView + (Double(numberOfColors) * Double(storedLogBoxSize.width)), height: helperViewHeight)
        let helperView = UIView.init(frame: CGRect.init(origin: CGPoint.init(x: Double(storedLogBoxPoint.x) - Double(helperViewSize.width), y: Double(storedLogBoxPoint.y)), size: helperViewSize))
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
        var helperBoxPointX:Double = Double(helpLabelLess.frame.size.width) + margin
        
        for index in 0..<numberOfColors {
            let helpLogLabel = UILabel.init(frame: CGRect.init(x: helperBoxPointX, y: 0.0, width: Double(storedLogBoxSize.width), height: Double(storedLogBoxSize.height)))
            helpLogLabel.backgroundColor = logColorsArray[index]
            helperView.addSubview(helpLogLabel)
            helperBoxPointX = helperBoxPointX + Double(helpLogLabel.frame.size.width) + margin
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
    public func setup(withYear year:Int) -> Void {
        clearExistingWHView()
        self.addLogColors()
        self.addWorkLogs(forYear: year)
    }
    
    fileprivate func clearExistingWHView() -> Void {
        for allTheSubviews in self.subviews {
            allTheSubviews.removeFromSuperview()
        }
    }
}
