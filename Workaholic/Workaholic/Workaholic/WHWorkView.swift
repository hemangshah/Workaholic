//
//  WHWorkView.swift
//  Workaholic
//
//  Created by Hemang Shah on 6/5/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import UIKit

fileprivate let valueStandardWidthForHelperView: Double = 65.0
fileprivate let valueStandardHeightForTimeView: Double = 25.0
fileprivate let valueStandardHeightForHelperView: Double = 25.0

public class WHWorkView : UIView {
    
    fileprivate var logColors = Array<UIColor>()
    fileprivate var contributions = Array<WHContribution>()
    
    ///Get Taps when user taps on a day in WorkView.
    public var onWorkLogTapCompletion:((_ date: WHDate) -> ())? = nil
    
    ///Set color when there's no log history.
    public var zeroPercentageLoggedColor: UIColor = UIColor.colorFromRGB(r: 238.0, g: 238.0, b: 238.0, alpha: 1.0)
    ///Set color when there's 25% log history.
    public var twenty5percentageLoggedColor = UIColor.colorFromRGB(r: 197.0, g: 229.0, b: 134.0, alpha: 1.0)
    ///Set color when there's 50% log history.
    public var fiftyPercentageLoggedColor = UIColor.colorFromRGB(r: 120.0, g: 202.0, b: 107.0, alpha: 1.0)
    ///Set color when there's 75% log history.
    public var seventy5percentageLoggedColor = UIColor.colorFromRGB(r: 25.0, g: 155.0, b: 53.0, alpha: 1.0)
    ///Set color when there's 100% log history.
    public var hundreadPercentageLoggedColor = UIColor.colorFromRGB(r: 20.0, g: 98.0, b: 36.0, alpha: 1.0)
    ///Set border color for WorkView.
    public var workViewBorderColor = UIColor.lightGray.cgColor
    
    ///Set days for WorkView (at left). Usage: to set localize days.
    public var workViewDays = ["Mon", "Wed", "Fri"]
    ///Set months for WorkView (at top). Usage: to set localize months.
    public var workViewMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    ///Days Label Title Color.
    public var daysLabelTitleColor = UIColor.colorFromRGB(r: 118.0, g: 118.0, b: 118.0, alpha: 1.0)
    ///Months Label Title Color.
    public var monthLabelTitleColor = UIColor.colorFromRGB(r: 118.0, g: 118.0, b: 118.0, alpha: 1.0)
    ///Less Label Title Color.
    public var lessLabelTitleColor = UIColor.colorFromRGB(r: 118.0, g: 118.0, b: 118.0, alpha: 1.0)
    ///More Label Title Color.
    public var moreLabelTitleColor = UIColor.colorFromRGB(r: 118.0, g: 118.0, b: 118.0, alpha: 1.0)
    
    ///Show Days In WorkView.
    public var showDaysInWorkView = false
    
    //MARK: Init with Frame
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = workViewBorderColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Add Workaholic View
    fileprivate func addWorkLogs(forYear logsForYear: Int) -> Void {
        
        let nowYear = Date(year: logsForYear, month: 1, day: 1)
        let nowYearString = nowYear.toString(format: .isoYear)
        
        let initialMargin: Double = 35.0
        let margin: Double = 2.0
        let numberOfLogsInColumn = nowYear.numberOfDaysInWeek()
        
        var logBoxPointX: Double = Double(initialMargin + margin)
        var logBoxPointY: Double = valueStandardHeightForTimeView + margin
        
        //Start - Calculating Box Sizes.
        //We know that there will always 12 months but for a change we are using a method to calculate total months.
        let totalMonths: NSInteger = nowYear.numberOfMonthsInYear()

        //Total numbers of Columns [Log Boxes] in each Row.
        let numberOfColumnsInEachRow: Double = Double(nowYear.numberOfDaysInYear()/numberOfLogsInColumn)

        //Calculate Width & Height of Log Boxes. We are taking the floor value to fixed the space.
        let logBoxWidthAndHeight: Double = floor(((self.width() - ((numberOfColumnsInEachRow * margin) + logBoxPointX))/numberOfColumnsInEachRow))
        
        //Create Log Box Size.
        let logBoxSize = CGSize.init(width: Double(logBoxWidthAndHeight), height: Double(logBoxWidthAndHeight))

        //------------------------------------------------------------------------
        //Start - Days Label
        //Labels: Mon / Wed / Fri
        
        //Update logBoxPointY for Days Label
        logBoxPointY = logBoxPointY + Double(logBoxSize.height) + margin
        
        for rowIndex in 1...3 {
            let daysLabel = createLabel(withFrame: CGRect.init(x: margin, y: logBoxPointY, width: initialMargin - (margin * 2.0), height: Double(logBoxSize.height)), text: "", font: UIFont.systemFont(ofSize: ((logBoxSize.width >= 10) ? 8.0 : 5.0)), textColor: self.daysLabelTitleColor, textAlignment: .right)
            let arrayIndex = (rowIndex - 1 )
            daysLabel.text = workViewDays[arrayIndex]
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
        var previousMonthIndex = 0
        
        for monthIndex in 0...totalMonths {
            
            //monthIndex = 0 because we have to show the days from previous year.
            
            if monthIndex == 0 {

                var remainingDays = (nowYear.weekdayDiffence() - 1)
                if remainingDays <= 0 {
                    remainingDays = 7
                }
                let previousYearDate = nowYear - remainingDays.days
                let previousYear = previousYearDate?.year
                let previousMonth = previousYearDate?.month
                //------------------------------------------------------------------------
                //Start – Internal Loop
                for columnIndex in previousYearDate!.day...previousYearDate!.numberOfDaysInMonth() {
                    
                    let workButton = WHButton()
                    workButton.frame = CGRect.init(x: Double(logBoxPointX), y: Double(logBoxPointY), width: Double(logBoxSize.width), height: Double(logBoxSize.height))
                    workButton.addTarget(self, action: #selector(actionDayTapped), for: .touchUpInside)
                    workButton.backgroundColor = zeroPercentageLoggedColor
                    self.addSubview(workButton)
                    
                    let whDate = WHDate.init()
                    whDate.date = Date(year: (previousYear)!, month: (previousMonth)!, day: columnIndex)
                    whDate.day = columnIndex
                    whDate.month = previousMonth
                    whDate.year = previousYear
                    
                    let currentDateOfLoop = whDate.date!
                    workButton.workDate = whDate
                    
                    if !hasContributions() {
                        let contribution = self.hasContributionsOnThisDate(date: currentDateOfLoop)
                        if (contribution != nil) {
                            workButton.backgroundColor = self.colorForWorkPercentage(percentage: contribution!.percentageOfWork)
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
                    
                    if showDaysInWorkView {
                        workButton.setTitleColor(.black, for: .normal)
                        workButton.titleLabel?.font = UIFont.systemFont(ofSize: 3.0)
                        workButton.setTitle(String(columnIndex), for: .normal)
                    } else {
                        workButton.setTitle("", for: .normal)
                    }
                }
                //End – Internal Loop
                //------------------------------------------------------------------------
                
            } else {
                
                let dateOfMonth = Date.init(fromString: "01-\(monthIndex)-\(nowYearString)", format: .custom("dd-M-yyyy"))
                let numberOfDaysInMonth = dateOfMonth!.numberOfDaysInMonth()
                let currentYear = dateOfMonth?.year
                let currentMonth = dateOfMonth?.month
                
                //------------------------------------------------------------------------
                //Start – Internal Loop
                for columnIndex in 1...numberOfDaysInMonth {
                    
                    let workButton = WHButton()
                    workButton.frame = CGRect.init(x: Double(logBoxPointX), y: Double(logBoxPointY), width: Double(logBoxSize.width), height: Double(logBoxSize.height))
                    workButton.addTarget(self, action: #selector(actionDayTapped), for: .touchUpInside)
                    workButton.backgroundColor = zeroPercentageLoggedColor
                    self.addSubview(workButton)
                                        
                    let whDate = WHDate.init()
                    whDate.date = Date(year: (dateOfMonth?.year)!, month: monthIndex, day: columnIndex)
                    whDate.day = columnIndex
                    whDate.month = currentMonth
                    whDate.year = currentYear
                    
                    let currentDateOfLoop = whDate.date!
                    workButton.workDate = whDate
                    
                    if !hasContributions() {
                        let contribution = hasContributionsOnThisDate(date: currentDateOfLoop)
                        if (contribution != nil) {
                            workButton.backgroundColor = self.colorForWorkPercentage(percentage: contribution!.percentageOfWork)
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
                    
                    if showDaysInWorkView {
                        workButton.setTitleColor(.black, for: .normal)
                        workButton.titleLabel?.font = UIFont.systemFont(ofSize: 3.0)
                        workButton.setTitle(String(columnIndex), for: .normal)
                    } else {
                        workButton.setTitle("", for: .normal)
                    }
                    
                    //------------------------------------------------------------------------
                    //Start - Months Label
                    //Labels: Jan, Feb, Mar
                    
                    if previousMonthIndex != monthIndex {
                        previousMonthIndex = monthIndex
                        let monthLabel = createLabel(withFrame: CGRect.init(x: logBoxPointX, y: 0.0, width: (Double((numberOfDaysInMonth/numberOfLogsInColumn)) * Double(logBoxSize.width)) + margin, height: valueStandardHeightForTimeView), text: self.monthNameForMonthIndex(monthIndex: monthIndex), font: UIFont.systemFont(ofSize: 10.0), textColor: self.monthLabelTitleColor, textAlignment: .center)
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
    
    //MARK: Actions
    @objc fileprivate func actionDayTapped(sender: WHButton) -> Void {                
        if onWorkLogTapCompletion != nil {
            onWorkLogTapCompletion!(sender.workDate!)
        }
    }
    
    //MARK: Month Name
    fileprivate func monthNameForMonthIndex(monthIndex: NSInteger) -> String {
        let arrayIndex = (monthIndex - 1)
        return self.workViewMonths[arrayIndex]
    }
    
    //MARK: Color for Work Percentage
    fileprivate func colorForWorkPercentage(percentage: WorkPecentage) -> UIColor {
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
        logColors.clean()
        logColors.append(zeroPercentageLoggedColor)
        logColors.append(twenty5percentageLoggedColor)
        logColors.append(fiftyPercentageLoggedColor)
        logColors.append(seventy5percentageLoggedColor)
        logColors.append(hundreadPercentageLoggedColor)
    }
    
    //MARK: Create Label
    fileprivate func createLabel(withFrame frame: CGRect, text: String, font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment) -> UILabel {
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
    fileprivate func addHelper(withLogBoxPoints storedLogBoxPoint: CGPoint, withLogBoxSize storedLogBoxSize: CGSize) -> Void {
        let margin:Double = 2.0
        let numberOfColors = logColors.count
        
        let remainingDifference = (self.height() - Double(storedLogBoxPoint.y))
        let helperViewHeight = (remainingDifference > valueStandardHeightForHelperView) ? valueStandardHeightForHelperView : remainingDifference
        
        //Helper View
        let helperViewSize = CGSize.init(width: valueStandardWidthForHelperView + (Double(numberOfColors) * Double(storedLogBoxSize.width)), height: helperViewHeight)
        let helperView = UIView.init(frame: CGRect.init(origin: CGPoint.init(x: Double(storedLogBoxPoint.x) - Double(helperViewSize.width), y: Double(storedLogBoxPoint.y)), size: helperViewSize))
        helperView.backgroundColor = UIColor.clear
        self.addSubview(helperView)

        //Label: Less
        let helpLabelLess = createLabel(withFrame:  CGRect.init(x: 0.0, y: 0.0 + margin, width: 25.0, height: 10.0), text: "Less", font: UIFont.systemFont(ofSize: 8.0), textColor: lessLabelTitleColor, textAlignment: .left)
        helperView.addSubview(helpLabelLess)
        helpLabelLess.center = CGPoint.init(x: helpLabelLess.center.x, y: helperView.frame.size.height/2.0)
        
        //Log Boxes Progress
        var helperBoxPointX:Double = Double(helpLabelLess.frame.size.width) + margin
        
        for index in 0..<numberOfColors {
            let helpLogLabel = UILabel.init(frame: CGRect.init(x: helperBoxPointX, y: 0.0, width: Double(storedLogBoxSize.width), height: Double(storedLogBoxSize.height)))
            helpLogLabel.backgroundColor = logColors[index]
            helperView.addSubview(helpLogLabel)
            helperBoxPointX = helperBoxPointX + Double(helpLogLabel.frame.size.width) + margin
            helpLogLabel.center = CGPoint.init(x: helpLogLabel.center.x, y: helperView.frame.size.height/2.0)
        }
        
        //Label: More
        let helpLabelMore = createLabel(withFrame:  CGRect.init(x: helperBoxPointX, y: 0.0, width: 25.0, height: 10.0), text: "More", font: UIFont.systemFont(ofSize: 8.0), textColor: moreLabelTitleColor, textAlignment: .right)
        helperView.addSubview(helpLabelMore)
        helpLabelMore.center = CGPoint.init(x: helpLabelMore.center.x, y: helperView.frame.size.height/2.0)
    }
    
    //MARK: Setup Helpers
    fileprivate func cleanWorkView() -> Void {
        contributions.clean()
        for allTheSubviews in self.subviews {
            allTheSubviews.removeFromSuperview()
        }
    }
    
    //MARK: Contributions Check
    fileprivate func hasContributions() -> Bool {
        return contributions.isEmpty
    }
    
    fileprivate func hasContributionsOnThisDate(date: Date) -> WHContribution? {
        let results = contributions.filter { $0.date.compare(.isSameDay(as: date)) }
        return results.isEmpty ? nil : results.first!
    }
    
    //MARK: Setup
    ///Once WHWorkView has been defined and set with necessory properties you can should call this function to invoke WHWorkView.
    public func reload(withYear year: Int, withContributions contributions: Array<WHContribution>) -> Void {
        cleanWorkView()
        self.contributions.append(contentsOf: contributions)
        self.addLogColors()
        self.addWorkLogs(forYear: year)
    }
}
