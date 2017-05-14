//
//  Helper.swift
//  WKBrowser
//
//  Created by dali on 20/04/2017.
//  Copyright © 2017 itdali. All rights reserved.
//

import Foundation

struct Helper {
    
    
    /// Current date with format
    ///
    /// - Parameter format: date format such like 'yyyyMMddHHmmss'
    /// - Returns: date string
    static func currentDate(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date())
    }
}
