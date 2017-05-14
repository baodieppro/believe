//
//  WebsiteModal.swift
//  WKBrowser
//
//  Created by dali on 16/04/2017.
//  Copyright © 2017 itdali. All rights reserved.
//

import UIKit

class WebsiteModal: NSObject {
    private var id: Int!
    var title: String = ""
    var url: String = ""
    var date: String = ""
    
    init(id: Int, title: String, url: String, date: String){
        self.id = id
        self.title = title
        self.url = url
        self.date = date
    }
    override init() {
        super.init()
    }
}
