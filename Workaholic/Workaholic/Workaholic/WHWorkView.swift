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

public class WHWorkView : UIView {
    
    fileprivate var logColorsArray = Array<UIColor>()
    fileprivate var contributionsArray = Array<WHContributions>()
    
    //MARK: Init with Frame
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
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
        //We know that there will always 12 months but for a change we are using a method to calculate total months.
        let totalMonths:NSInteger = nowYear.numberOfMonthsInYear()

        //Total numbers of Columns [Log Boxes] in each Row.
        let numberOfColumnsInEachRow:Double = Double(nowYear.numberOfDaysInYear()/numberOfLogsInColumn)

        //Calculate Width & Height of Log Boxes. We are taking the floor value to fixed the space.
        let logBoxWidthAndHeight:Double = floor(((self.getMyWidth() - ((numberOfColumnsInEachRow * margin) + logBoxPointX))/numberOfColumnsInEachRow))
        
        //Create Log Box Size.
        let logBoxSize = CGSize.init(width: Double(logBoxWidthAndHeight), height: Double(logBoxWidthAndHeight))
 
        //------------------------------------------------------------------------
        //Start - Days Label
        //Labels: Mon / Wed / Fri
        
        //Update logBoxPointY for Days Label
        logBoxPointY = logBoxPointY + Double(logBoxSize.height) + margin
        
        for rowIndex in 1...3 {
            let daysLabel = createLabel(withFrame: CGRect.init(x: margin, y: logBoxPointY, width: initialMargin - (margin * 2.0), height: Double(logBoxSize.height)), text: "", font: UIFont.systemFont(ofSize: ((logBoxSize.width >= 10) ? 8.0 : 5.0)), textColor: UIColor.init(red: 118.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0), textAlignment: .right)
            
            if rowIndex == 1 {
                daysLabel.text = "Mon"
                
            } else if rowIndex == 2 {
                daysLabel.text = "Wed"
                
            } else if rowIndex == 3 {
                daysLabel.text = "Fri"
            }
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
                    self.addSubview(workLabel)
                    
                    let currentDateOfLoop = Date(year: (previousYearDate?.year)!, month: (previousYearDate?.month)!, day: columnIndex)
                    
                    if !isContributionsEmpty() {
                        let contribution = isContributedOnThisDate(date: currentDateOfLoop)
                        if (contribution != nil) {
                            workLabel.backgroundColor = colorForWorkPercentage(percentage: contribution!.whcWorkPercentage)
                        }
                    }
                    
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
                    workLabel.backgroundColor = zeroPercentageLoggedColor
//                    workLabel.text = "\(columnIndex)"
//                    workLabel.textAlignment = .center
//                    workLabel.font = UIFont.systemFont(ofSize: 3)
                    self.addSubview(workLabel)
                    
                    let currentDateOfLoop = Date(year: (dateOfMonth?.year)!, month: monthIndex, day: columnIndex)
                    
                    if !isContributionsEmpty() {
                        let contribution = isContributedOnThisDate(date: currentDateOfLoop)
                        if (contribution != nil) {
                            workLabel.backgroundColor = colorForWorkPercentage(percentage: contribution!.whcWorkPercentage)
                        }
                    }
                    
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
                        let monthLabel = createLabel(withFrame: CGRect.init(x: logBoxPointX, y: 0.0, width: (Double((numberOfDaysInMonth/numberOfLogsInColumn)) * Double(logBoxSize.width)) + margin, height: valueStandardHeightForTimeView), text: monthNameForMonthIndex(monthIndex: monthIndex), font: UIFont.systemFont(ofSize: 10.0), textColor: UIColor.init(red: 118.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0), textAlignment: .center)
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
        
        //Add Helper View : Less ººººº More
        self.addHelper(withLogBoxPoints: CGPoint.init(x: logBoxPointX, y: Double(Double(numberOfLogsInColumn) * Double(logBoxSize.height)) + valueStandardHeightForTimeView + (margin * Double(numberOfLogsInColumn)) + margin), withLogBoxSize: logBoxSize)
    }
    
    //MARK: Month Name
    fileprivate func monthNameForMonthIndex(monthIndex:NSInteger) -> String {
        
        if monthIndex == 1 {
            return "Jan"
            
        } else if monthIndex == 2 {
            return "Feb"
            
        } else if monthIndex == 3 {
            return "Mar"
            
        } else if monthIndex == 4 {
            return "Apr"
            
        } else if monthIndex == 5 {
            return "May"
            
        } else if monthIndex == 6 {
            return "Jun"
            
        } else if monthIndex == 7 {
            return "Jul"
            
        } else if monthIndex == 8 {
            return "Aug"
            
        } else if monthIndex == 9 {
            return "Sep"
            
        } else if monthIndex == 10 {
            return "Oct"
            
        } else if monthIndex == 11 {
            return "Nov"
            
        } else if monthIndex == 12 {
            return "Dec"
            
        }
        return ""
    }
    
    //MARK: Color for Work Percentage
    fileprivate func colorForWorkPercentage(percentage:WHWorkPecentage) -> UIColor {
        switch percentage {
        case .hundread:
            return hundreadPercentageLoggedColor
        case .seventyFive:
            return seventy5percentageLoggedColor
        case .fifty:
            return fiftyPercentageLoggedColor
        case .twentyFive:
            return twenty5percentageLoggedColor
        default:
            return zeroPercentageLoggedColor
        }
    }
    
    //MARK: Add Logging Colors[0% to 100%]
    fileprivate func addLogColors() -> Void {
        logColorsArray.removeAll()
        logColorsArray.append(zeroPercentageLoggedColor)
        logColorsArray.append(twenty5percentageLoggedColor)
        logColorsArray.append(fiftyPercentageLoggedColor)
        logColorsArray.append(seventy5percentageLoggedColor)
        logColorsArray.append(hundreadPercentageLoggedColor)
    }
    
    //MARK: Create Label
    fileprivate func createLabel(withFrame frame:CGRect, text:String, font:UIFont, textColor:UIColor, textAlignment:NSTextAlignment) -> UILabel {
        let label = UILabel.init(frame: frame)
        label.backgroundColor = UIColor.clear
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.minimumScaleFactor = (UIFont.labelFontSize/2)/UIFont.labelFontSize
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    //MARK: Add Helper UI [Less/More]
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
        let helpLabelLess = createLabel(withFrame:  CGRect.init(x: 0.0, y: 0.0 + margin, width: 25.0, height: 10.0), text: "Less", font: UIFont.systemFont(ofSize: 8.0), textColor: UIColor.init(red: 118.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0), textAlignment: .left)
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
        let helpLabelMore = createLabel(withFrame:  CGRect.init(x: helperBoxPointX, y: 0.0, width: 25.0, height: 10.0), text: "More", font: UIFont.systemFont(ofSize: 8.0), textColor: UIColor.init(red: 118.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0), textAlignment: .right)
        helperView.addSubview(helpLabelMore)
        helpLabelMore.center = CGPoint.init(x: helpLabelMore.center.x, y: helperView.frame.size.height/2.0)
    }
    
    //MARK: Setup Helpers
    fileprivate func clearExistingWHView() -> Void {
        contributionsArray.removeAll()
        for allTheSubviews in self.subviews {
            allTheSubviews.removeFromSuperview()
        }
    }
    
    //MARK: Contributions Check
    func isContributionsEmpty() -> Bool {
        return contributionsArray.isEmpty
    }
    
    func isContributedOnThisDate(date:Date) -> WHContributions? {
        let results = contributionsArray.filter { $0.whcDate.compare(.isSameDay(as: date)) }
        return results.isEmpty ? nil : results.first!
    }
    
    //MARK: Setup Everything!
    public func setup(withYear year:Int, withContributions contributions:Array<WHContributions>) -> Void {
        clearExistingWHView()
        contributionsArray.append(contentsOf: contributions)
        self.addLogColors()
        self.addWorkLogs(forYear: year)
    }
}
