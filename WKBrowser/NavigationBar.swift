//
//  NavigationBar.swift
//  WKBrowser
//
//  Created by dali on 20/04/2017.
//  Copyright © 2017 itdali. All rights reserved.
//

import UIKit

protocol NavigationBarDelegate: class {
    func navigationBarDoneClick(_ navigationBar: UINavigationBar)
}

class NavigationBar: UINavigationBar {
    
    weak var delegateExtension: NavigationBarDelegate?
    private var doneBtn: UIBarButtonItem!
    private var navItem: UINavigationItem!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClick))
        
        navItem = UINavigationItem()
        navItem.setRightBarButtonItems([doneBtn], animated: true)
        navItem.title = Constants.strings.historyNavigationBarTitle
        
        self.setItems([navItem], animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func doneClick() {
        delegateExtension?.navigationBarDoneClick(self)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }

}
