//
//  Header.swift
//  iOS-Show
//
//  Created by dali on 16/4/29.
//  Copyright © 2016年 dali. All rights reserved.
//
// =============== 自定义全局的变量、语句等 ======================

import Foundation
import UIKit

struct Paths {
    static let documents: String = NSHomeDirectory() + "/Documents"
    static let library: String = NSHomeDirectory() + "/Library"
}


/// 自定义输出语句，代替系统输出，打包时禁掉即可
///
/// - Parameters:
///   - message: 要输出的内容
///   - file: 文件名
///   - method: 方法名
///   - line: 行号
public func DLprint <T>(_ message: T,
    file: String = #file,
    method: String = #function,
    line: Int = #line)
{
    #if DEVELOPMENT
        //print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        print("\((file as NSString).lastPathComponent)[\(line)]: \(message)")
    #else
    
    #endif
}


/// Print function name and line number
///
/// - Parameters:
///   - method: function name
///   - line: line number
public func DLfunction (method: String = #function, line: Int = #line) {
    #if DEVELOPMENT
        print("\(line).\(method)")
    #else
        
    #endif
}

