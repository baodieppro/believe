//
//  Constants.swift
//  WKBrowser
//
//  Created by dali on 18/04/2017.
//  Copyright © 2017 itdali. All rights reserved.
//

import Foundation

struct Constants {
    struct colors {
        static let blue = UIColor(rgb: 0x2E90DF)
        static let lightGray = UIColor.lightGray
        static let toolBarTitle = blue.changeBlackness(step: 0.2)
        static let toolBarBackground = UIColor.white
        static let textFieldBackground = UIColor(white: 0.9, alpha: 1.0)
        static let introBackground = UIColor(rgb: 0xA9D5F8)
    }
    
    struct fonts {
        static let textField = UIFont.systemFont(ofSize: 12)
        static let toolBarTitle = UIFont.systemFont(ofSize: 14)
    }
    
    struct layout {
        static let screenWidth = UIScreen.main.bounds.width
        static let screenHeight = UIScreen.main.bounds.height
        
        static let toolBarH: CGFloat = 49
        static let navigationBarH: CGFloat = 44
        
        static let websiteTitleH: CGFloat = 24
    }
    
    struct strings {
        static let browserErrorLink = NSLocalizedString("Browser.errorLink", value: "The link is wrong!", comment: "Show error link")
        static let titlePlaceholderText = NSLocalizedString("Title.placeholderText", value: "Search or enter address", comment: "Placeholder text shown in title bar while open a blank page")
        static let urlPlaceholderText = NSLocalizedString("URL.placeholderText", value: "Search or enter address", comment: "Placeholder text shown in url bar before input")
        static let historyNavigationBarTitle = NSLocalizedString("History.navigationBarTitle", value: "History", comment: "NavigationBar title shown in history page")
        static let websiteManageBookmarkTitle = NSLocalizedString("websiteManage.bookmarkTitle", value: "bookmark", comment: "Segmented Controller Title 'bookmark' in WebsiteManageView")
        static let websiteManageHistoryTitle = NSLocalizedString("websiteManage.historyTitle", value: "history", comment: "Segmented Controller Title 'history' in WebsiteManageView")
        static let historyClearBtnTitle = NSLocalizedString("History.clearBtnTitle", value: "Clear", comment: "Clear button title in history page ")
    }
    
    struct identifiers {
        static let historyCellID: String = "historyCellID"
    }
}
