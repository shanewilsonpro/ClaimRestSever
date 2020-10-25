//
//  database.swift
//  ClaimRestSever
//
//  Created by Shane Wilson on 10/24/20.
//

import SQLite3

class Database {
    static var dbObj : Database!
    // Change database name based on user directory - sh: pwd
    let dbname = "/Users/brianchung/Documents/Github.nosync/ClaimSwiftRestServer/Claims.sqlite"
    var conn : OpaquePointer?
    
    init() {
        // 1. create database
        if sqlite3_open(dbname, &conn) == SQLITE_OK {
            // 2. Create tables
            initializeDB()
            sqlite3_close(conn)
        } else {
            let errcode = sqlite3_errcode(conn)
            print("Open database failed due to error \(errcode)")
        }
    }
    
    private func initializeDB() {
        let sqlStmt = "create table if not exists claim (id text, title text, date text, isSolved int)"
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("Create table failed due to error \(errcode)")
        }
    }
    
    func getDbConnection() -> OpaquePointer? {
        var conection : OpaquePointer?
        if sqlite3_open(dbname, &conection) == SQLITE_OK {
            // No need to initializeDB again
            // initializeDB()
        } else {
            let errcode = sqlite3_errcode(conection)
            print("Open database failed due to error \(errcode)")
        }
        return conection
    }
    
    static func getInstance() -> Database {
        if dbObj == nil {
            dbObj = Database()
        }
        return dbObj
    }
}
