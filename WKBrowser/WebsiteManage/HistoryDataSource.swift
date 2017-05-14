//
//  HistoryDataSource.swift
//  WKBrowser
//
//  Created by dali on 19/04/2017.
//  Copyright © 2017 itdali. All rights reserved.
//

import Foundation

protocol HistoryDataSourceDelegate: class {
    func historyViewOpenUrl(with string: String)
}

class HistoryDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegateExtension: HistoryDataSourceDelegate?
    
    private var cellID: String = ""
    private var items: Array<WebsiteModal> = []
    private var configureCell: (()-> Void)?
    
    
    init(with items: Array<WebsiteModal>, identifier id: String, configureCell: @escaping () -> Void) {
        super.init()
        self.items = items
        self.cellID = id
        self.configureCell = configureCell
        DLprint(self.cellID)
    }
    override init() {
        super.init()
    }
    
    //MARK:- Table View DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        DLfunction()
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DLprint(items.count)
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        DLfunction()
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        }
        let modal: WebsiteModal = items[indexPath.row]
        cell?.textLabel?.text = modal.title
        cell?.detailTextLabel?.text = modal.url
        return cell!
    }
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section - \(section)"
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }*/
    
    //MARK:- Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DLprint("section: \(indexPath.section), row: \(indexPath.row)")
        let modal: WebsiteModal = items[indexPath.row]
        delegateExtension?.historyViewOpenUrl(with: modal.url)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "delete"
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        DLprint("delete - section: \(indexPath.section), row: \(indexPath.row)")
    }
}
