//
//  WebsiteManageController.swift
//  WKBrowser
//
//  Created by dali on 16/04/2017.
//  Copyright © 2017 itdali. All rights reserved.
//

import UIKit

protocol WebsiteManageControllerDelegate: class {
    func websiteManage(_ websiteManage: UIViewController, openUrlWith string: String)
}

class WebsiteManageController: UIViewController {
    
    weak var delegateExtension: WebsiteManageControllerDelegate?
    
    private var navBar: NavigationBar!
    private var historyView: HistoryView!
    private var historyDataSource: HistoryDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
        setupHistoryView()
    }
    
    private func setupNavigationBar() {
        navBar = NavigationBar(frame: CGRect(x: 0, y: 20, width: Constants.layout.screenWidth, height: Constants.layout.navigationBarH))
        navBar.delegateExtension = self
        view.addSubview(navBar)
    }
    
    private func setupHistoryView() {
        historyView = HistoryView(frame: CGRect(x: 0, y: 64, width: Constants.layout.screenWidth, height: Constants.layout.screenHeight-64))
        let items = DataBaseManager.query(table: .history)
        historyDataSource = HistoryDataSource(with: items, identifier: Constants.identifiers.historyCellID, configureCell: {() -> Void in})
        historyDataSource.delegateExtension = self
        historyView.tableView.dataSource = historyDataSource
        historyView.tableView.delegate = historyDataSource
        view.addSubview(historyView)
    }
    
    deinit {
        DLprint("")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        DLprint("")
    }
}

extension WebsiteManageController: NavigationBarDelegate {
    func navigationBarDoneClick(_ navigationBar: UINavigationBar) {
        dismiss(animated: true, completion: nil)
    }
}

extension WebsiteManageController: HistoryDataSourceDelegate {
    func historyViewOpenUrl(with string: String) {
        delegateExtension?.websiteManage(self, openUrlWith: string)
        dismiss(animated: true, completion: nil)
    }
}
