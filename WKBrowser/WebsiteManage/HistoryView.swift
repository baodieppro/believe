//
//  HistoryView.swift
//  WKBrowser
//
//  Created by dali on 19/04/2017.
//  Copyright © 2017 itdali. All rights reserved.
//

import UIKit


/*
private enum HistoryClearStyle: String {
    case theLastHour = "The last hour"
    case today = "Today"
    case todayAndYesterday = "Today and yesterday"
    case allTime = "All time"
}
 */

class HistoryView: UIView {
    
    var tableView: UITableView!
    private var toolBar: UIToolbar!
    private var clearBtn: UIBarButtonItem!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), style: .plain)
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.identifiers.historyCellID)
        tableView.tableFooterView = UIView()
        self.addSubview(tableView)
        
        /*
        toolBar = UIToolbar(frame: CGRect(x: 0, y: tableView.frame.maxY, width: frame.width, height: Constants.layout.toolBarH))
        toolBar.backgroundColor = Constants.colors.toolBarBackground
        toolBar.tintColor = Constants.colors.blue
        self.addSubview(toolBar)
        
        clearBtn = UIBarButtonItem(title: Constants.strings.historyClearBtnTitle, style: .plain, target: self, action: #selector(clearClick))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([flexibleSpace,clearBtn], animated: true)
         */
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func clearClick() {
        DLfunction()
    }
}
