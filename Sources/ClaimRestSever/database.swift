//
//  database.swift
//  ClaimRestSever
//
//  Created by Shane Wilson on 10/24/20.
//

import SQLite3

class Database {
    static var dbVar : Database!
    let dbName = "/Users/shanewilson/Documents/ClaimRestServer/Claims.sqlite"
    var conn : OpaquePointer?
    
    // create database
    init() {
        if sqlite3_open(dbName, &conn) == SQLITE_OK {
            initializeDB()
            sqlite3_close(conn)
        } else {
            let errcode = sqlite3_errcode(conn)
            print("Open database failed due \(errcode)")
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
        if sqlite3_open(dbName, &conection) == SQLITE_OK {
            //nothing
        } else {
            let errcode = sqlite3_errcode(conection)
            print("Open database failed due \(errcode)")
        }
        return conection
    }
    
    static func getInstance() -> Database {
        if dbVar == nil {
            dbVar = Database()
        }
        return dbVar
    }
}
