//
//  WKIntroductionViewController.swift
//  WKBrowser
//
//  Created by dali on 18/04/2017.
//  Copyright © 2017 itdali. All rights reserved.
//

import UIKit

class IntroductionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.colors.introBackground
        
        loadAllView()
    }
    
    
    private func loadAllView() {
        
        let showLabel: UILabel = UILabel()
        showLabel.text = "This is Introduction View"
        showLabel.frame = CGRect(x: 0, y: 100, width: Constants.layout.screenWidth, height: 50)
        showLabel.textAlignment = .center
        view.addSubview(showLabel)
        
        let tempBtn: UIButton = UIButton()
        tempBtn.setTitle("done", for: .normal)
        tempBtn.setTitleColor(UIColor.blue, for: .normal)
        tempBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tempBtn.addTarget(self, action: #selector(tempClick), for: UIControlEvents.touchUpInside)
        tempBtn.frame = CGRect(x: 100, y: 200, width: 100, height: 50)
        view.addSubview(tempBtn)
    }
    
    @objc private func tempClick() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
