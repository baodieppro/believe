//
//  SQLiteManager.swift
//  WKBrowser
//
//  Created by dali on 17/04/2017.
//  Copyright © 2017 itdali. All rights reserved.
//

import UIKit


private let DBFILE_NAME: String = "WKData.sqlite3"
private let DB_PATH: String = Paths.documents.appending("/WKData.sqlite3")

class SQLiteManager: NSObject {
    // 对外提供创建单例对象的接口
    public class var share: SQLiteManager {
        struct Singleton {
            static let instance = SQLiteManager()
        }
        return Singleton.instance
    }
    // 定义数据库变量
    var db: OpaquePointer? = nil
    
    // SQLite
    //var db: Connection?
    
    func connect() {
        
        // 只接受C语言的字符串，所以要把DBPath这个NSString类型的转换为cString类型，用UTF8的形式表示
        let cDBPath = DB_PATH.cString(using: String.Encoding.utf8)
        
        // 第一个参数：数据库文件路径，这里是我们定义的cDBPath
        // 第二个参数：数据库对象，这里是我们定义的db
        // SQLITE_OK是SQLite内定义的宏，表示成功打开数据库
        
        guard sqlite3_open(cDBPath, &db) == SQLITE_OK else {
            DLprint("can not connect DataBase!")
            return
        }
        
        let createHistoryTable = "CREATE TABLE IF NOT EXISTS t_history (id    integer PRIMARY KEY AUTOINCREMENT,title TEXT     NOT NULL,url   TEXT     NOT NULL,date  DATETIME NOT NULL);"
        let createIndex = "CREATE UNIQUE INDEX IF NOT EXISTS url_index ON t_history (url);"
        if exec(SQL: (createHistoryTable+createIndex)) == false {
            // 失败
            DLprint("SQLite: CREATE TABLE t_history WRONG!")
        } else {
            DLprint("SQLite: CREATE TABLE t_history SUCCESS!")
        }
        
        
        /*
        let history = Table("history")
        let id = Expression<Int64>("id")
        let title = Expression<String>("title")
        let url = Expression<String>("url")
        let date = Expression<String>("date")
        
        do {
            db = try Connection(Paths.documents+"/WKData.sqlite3")
            
            try db?.run(history.create(ifNotExists: true, block: {t in
                t.column(id, primaryKey: true)
                t.column(title)
                t.column(url)
                t.column(date)
            }))
        } catch {
            DLprint(error)
        }
         */
    }
    
    // 查询数据库
    func query(SQL: String) -> [[String:AnyObject]]? {
        // 创建一个语句对象
        var statement: OpaquePointer? = nil
        if SQL.lengthOfBytes(using: String.Encoding.utf8) > 0 {
            let cSQL = SQL.cString(using: String.Encoding.utf8)!
            // 进行查询前的准备工作
            // 第一个参数：数据库对象，第二个参数：查询语句，第三个参数：查询语句的长度（如果是全部的话就写-1），第四个参数是：句柄（游标对象）
            if sqlite3_prepare_v2(db, cSQL, -1, &statement, nil) == SQLITE_OK {
                var queryDataArray = [[String:AnyObject]]()
                while sqlite3_step(statement) == SQLITE_ROW {
                    // 获取解析到的列
                    let columnCount = sqlite3_column_count(statement)
                    // 遍历某行数据
                    var temp = [String: AnyObject]()
                    for i in 0..<columnCount {
                        // 取出i位置列的字段名,作为temp的键key
                        let cKey = sqlite3_column_name(statement, i)
                        let key : String = String(validatingUTF8: cKey!)!
                        //取出i位置存储的值,作为字典的值value
                        let cValue = sqlite3_column_text(statement, i)
                        let value = String(cString: cValue!)
                        temp[key] = value as AnyObject
                    }
                    queryDataArray.append(temp)
                }
                return queryDataArray
            }
        }
        return nil
    }
    
    
    // 执行SQL语句的方法，传入SQL语句执行
    func exec(SQL : String) -> Bool {
        let cSQL = SQL.cString(using: String.Encoding.utf8)
        let errmsg : UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
        if sqlite3_exec(db, cSQL, nil, nil, errmsg) == SQLITE_OK {
            return true
        } else {
            DLprint("执行SQL语句: \(SQL) 时出错，错误信息为：\(String(describing: errmsg))")
            return false
        }
    }
}
