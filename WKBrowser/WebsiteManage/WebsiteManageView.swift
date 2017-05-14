//
//  WebsiteManageView.swift
//  WKBrowser
//
//  Created by dali on 14/05/2017.
//  Copyright © 2017 itdali. All rights reserved.
//

import UIKit

protocol WebsiteManageViewDelegate: class {
    func WebsiteManageViewOpenUrl(with string: String)
}

class WebsiteManageView: UIView {
    
    weak var delegateExtension: WebsiteManageViewDelegate?
    private var segmentedCtrl: UISegmentedControl!
    private var historyView: HistoryView!
    private var historyDataSource: HistoryDataSource!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.backgroundColor = UIColor.white
        
        segmentedCtrl = UISegmentedControl(frame: CGRect(x: 50, y: 10, width: frame.width-100, height: Constants.layout.websiteTitleH))
        segmentedCtrl.backgroundColor = UIColor.white
        segmentedCtrl.tintColor = UIColor.lightGray
        segmentedCtrl.insertSegment(withTitle: Constants.strings.websiteManageBookmarkTitle, at: 0, animated: true)
        segmentedCtrl.insertSegment(withTitle: Constants.strings.websiteManageHistoryTitle, at: 1, animated: true)
        segmentedCtrl.selectedSegmentIndex = 0
        segmentedCtrl.addTarget(self, action: #selector(segmentedCtrlClick(_:)), for: .valueChanged)
        self.addSubview(segmentedCtrl)
        
        historyView = HistoryView(frame: CGRect(x: 0, y: segmentedCtrl.frame.maxY+10, width: frame.width, height: frame.height-segmentedCtrl.frame.maxY-10))
        let items = DataBaseManager.query(table: .history)
        historyDataSource = HistoryDataSource(with: items, identifier: Constants.identifiers.historyCellID, configureCell: {() -> Void in})
        historyDataSource.delegateExtension = self
        historyView.tableView.dataSource = historyDataSource
        historyView.tableView.delegate = historyDataSource
        self.addSubview(historyView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func segmentedCtrlClick(_ sender: UISegmentedControl) {
        DLprint(sender.selectedSegmentIndex)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

extension WebsiteManageView: HistoryDataSourceDelegate {
    func historyViewOpenUrl(with string: String) {
        delegateExtension?.WebsiteManageViewOpenUrl(with: string)
    }
}
