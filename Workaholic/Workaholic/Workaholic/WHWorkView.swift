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

let valueStandardHeightForTimeView:CGFloat = 25.0

let zeroPercentageLoggedColor = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
let twenty5percentageLoggedColor = UIColor.init(red: 197.0/255.0, green: 229.0/255.0, blue: 134.0/255.0, alpha: 1.0)
let fiftyPercentageLoggedColor = UIColor.init(red: 120.0/255.0, green: 202.0/255.0, blue: 107.0/255.0, alpha: 1.0)
let seventy5percentageLoggedColor = UIColor.init(red: 25.0/255.0, green: 155.0/255.0, blue: 53.0/255.0, alpha: 1.0)
let hundreadPercentageLoggedColor = UIColor.init(red: 20.0/255.0, green: 98.0/255.0, blue: 36.0/255.0, alpha: 1.0)

class WHWorkView : UIView {
    
    var logColorsArray = Array<UIColor>()
    
    var storedLogBoxSize:CGSize?
    var storedLogBoxPointY:CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addTimeView() -> Void {
        let rect = CGRect.init(x: 0.0, y: 0.0, width: self.getMyWidth(), height: valueStandardHeightForTimeView)
        let timeView = WHTimeView.init(frame: rect)
        self.addSubview(timeView)
    }
    
    fileprivate func addWorkLogs() -> Void {
        let margin:CGFloat = 2.0
        let numberOfLogsInColumn = 7
        
        //Why 36? 12 months. Each month X 3 columns.
        let numberOfColumnsInEachRow:CGFloat = 12.0 * 3.0
        let logBoxWidth = ((self.getMyWidth() - (numberOfColumnsInEachRow * margin) - margin)/numberOfColumnsInEachRow)
        let logBoxSize = CGSize.init(width: logBoxWidth, height: logBoxWidth)
        
        storedLogBoxSize = logBoxSize
        
        var logBoxPointX = margin
        var logBoxPointY = valueStandardHeightForTimeView + margin
        
        let convertNumberOfColumnsInEachRow:NSInteger = NSInteger(numberOfColumnsInEachRow)
        for _ in 1...numberOfLogsInColumn {
            for _ in 1...convertNumberOfColumnsInEachRow {
                let workLabel = UILabel.init(frame: CGRect.init(x: logBoxPointX, y: logBoxPointY, width: logBoxSize.width, height: logBoxSize.height))
                workLabel.backgroundColor = logColorsArray.randomColor
                self.addSubview(workLabel)
                logBoxPointX = logBoxPointX + logBoxSize.width + margin
            }
            logBoxPointX = margin
            logBoxPointY = logBoxPointY + logBoxSize.height + margin
        }
        
        storedLogBoxPointY = logBoxPointY
    }
    
    fileprivate func addLogColors() -> Void {
        logColorsArray.append(zeroPercentageLoggedColor)
        logColorsArray.append(twenty5percentageLoggedColor)
        logColorsArray.append(fiftyPercentageLoggedColor)
        logColorsArray.append(seventy5percentageLoggedColor)
        logColorsArray.append(hundreadPercentageLoggedColor)
    }
    
    fileprivate func addHelper() -> Void {
        let margin:CGFloat = 2.0
        let numberOfColors = logColorsArray.count

        let helpLabelLess = UILabel.init(frame: CGRect.init(x: margin, y: storedLogBoxPointY! + margin, width: 30.0, height: 10.0))
        helpLabelLess.text = "Less"
        helpLabelLess.font = UIFont.systemFont(ofSize: 8.0)
        self.addSubview(helpLabelLess)
        
        var helperBoxPointX:CGFloat = helpLabelLess.frame.size.width + margin
        
        for index in 0..<numberOfColors {
            let helpLabel = UILabel.init(frame: CGRect.init(x: helperBoxPointX, y: storedLogBoxPointY! + margin, width: (storedLogBoxSize?.width)!, height: (storedLogBoxSize?.height)!))
            helpLabel.backgroundColor = logColorsArray[index]
            self.addSubview(helpLabel)
            helperBoxPointX = helperBoxPointX + helpLabel.frame.size.width + margin
        }
        
        let helpLabelMore = UILabel.init(frame: CGRect.init(x: helperBoxPointX + margin, y: storedLogBoxPointY! + margin, width: 30.0, height: 10.0))
        helpLabelMore.text = "More"
        helpLabelMore.font = UIFont.systemFont(ofSize: 8.0)
        self.addSubview(helpLabelMore)
    }
    
    public func setup() -> Void {
        self.addLogColors()
        self.addTimeView()
        self.addWorkLogs()
        self.addHelper()
    }
}
