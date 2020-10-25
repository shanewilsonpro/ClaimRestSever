//
//  ClaimDao.swift
//  ClaimRestSever
//
//  Created by Shane Wilson on 10/24/20.
//

import Foundation
import SQLite3


struct Claim : Codable {
    var id : UUID = UUID()
    var title : String
    var date : String
    var isSolved : Bool = false
    
    init(id: UUID?, title: String, date: String, isSolved: Bool?) {
        if (id != nil) {
            self.id = id!
        }
        if (isSolved != nil) {
            self.isSolved = isSolved!
        }
        self.title = title
        self.date = date
    }
}


class ClaimDao {
    func addClaim(claimObj: Claim) {
        let sqlStmt = "insert into claim (id, title, date, isSolved) values ('\(claimObj.id.uuidString)', '\(claimObj.title)', '\(claimObj.date)', '\(claimObj.isSolved ? 1 : 0)')"
        // Get database connection
        let conn = Database.getInstance().getDbConnection()
        // Submit the insert sql statement
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("Failed to insert claim record due to error \(errcode)")
        }
        sqlite3_close(conn)
    }
    
    func getAll() -> [Claim] {
        var claimList = [Claim]()
        var resultSet : OpaquePointer?
        let sqlStr = "select id, title, date, isSolved from claim"
        let conn = Database.getInstance().getDbConnection()
        if sqlite3_prepare_v2(conn, sqlStr, -1, &resultSet, nil) == SQLITE_OK {
            while(sqlite3_step(resultSet) == SQLITE_ROW) {
                // Convert the record into a Claim object
                // Unsafe Pointer<Uint8> Sqlite3
                let id_val = sqlite3_column_text(resultSet, 0)
                let id = UUID(uuidString: String(cString: id_val!))
                let title_val = sqlite3_column_text(resultSet, 1)
                let title = String(cString: title_val!)
                let date_val = sqlite3_column_text(resultSet, 2)
                let date = String(cString: date_val!)
                let isSolved_val = sqlite3_column_text(resultSet, 3)
                let isSolved_string = String(cString: isSolved_val!)
                let isSolved = Bool(truncating: Int(isSolved_string)! as NSNumber)
                claimList.append(Claim(id: id, title: title, date: date, isSolved: isSolved))
            }
        }
        sqlite3_close(conn)
        return claimList
    }
}
