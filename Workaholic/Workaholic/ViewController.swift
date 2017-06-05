//
//  ViewController.swift
//  Workaholic
//
//  Created by Hemang Shah on 6/5/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let marging:CGFloat = 20.0
        let topMargin:CGFloat = 80.0
        let width:CGFloat = UIScreen.main.bounds.size.width - (marging * 2.0)
        let height:CGFloat = 115.0//185.0
        let workView = WHWorkView.init(frame: CGRect.init(x: marging, y: topMargin, width: width, height: height))
        workView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        self.view.addSubview(workView)
        
        workView.layer.borderWidth = 1.0
    }
}
