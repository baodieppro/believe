//
//  DataBaseManager.swift
//  WKBrowser
//
//  Created by dali on 20/04/2017.
//  Copyright © 2017 itdali. All rights reserved.
//

import Foundation
import WebKit

enum DataBaseStyle: String {
    case history = "t_history"
    case bookmark = "t_bookmark"
}


struct DataBaseManager {
    static func update(table style: DataBaseStyle, with item: WKBackForwardListItem) {
        
        let currentDate = Helper.currentDate(with: "yyyyMMddHHmmss")
        let replaceSQL = "REPLACE INTO \(style.rawValue) (title,url,date) VALUES ('\(item.title!)','\(item.url)','\(currentDate)');"
        
        if SQLiteManager.share.exec(SQL: replaceSQL) == true{
            DLprint("SQLite: REPLACE SUCCESS!")
        } else {
            DLprint("SQLite: REPLACE WRONG!")
        }
    }
    
    static func query(table style: DataBaseStyle) -> Array<WebsiteModal> {
        var items: Array<WebsiteModal> = []
        let querySQL = "SELECT * FROM \(style.rawValue) ORDER BY date DESC ;"
        if let queryResult = SQLiteManager.share.query(SQL: querySQL) {
            DLprint(queryResult)
            for dict in queryResult {
                let modal = WebsiteModal(id: Int(dict["id"] as! String)!, title: dict["title"] as! String, url: dict["url"] as! String, date: dict["date"] as! String)
                items.append(modal)
            }
        }
        return items
    }
}
