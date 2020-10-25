// Shane Wilson

import Foundation
import Kitura
import Cocoa

print("Starting REST Server...")

let router = Router()

let dbObj = Database.getInstance()


router.all("/ClaimService/add", middleware: BodyParser())

router.get("/ClaimService/getAll") {request, response, next in
    let claimList = ClaimDao().getAll()
    // JSON Serialization
    let jsonData : Data = try JSONEncoder().encode(claimList)
    // JSONArray
    let jsonStr = String(data: jsonData, encoding: .utf8)
    response.send(jsonStr)
    next()
}


router.post("/ClaimService/add") { request, response, next in
    let body = request.body
    let jObj = body?.asJSON // JSON object
    if let jDict = jObj as? [String:String] {
        if let title = jDict["title"], let date = jDict["date"] {
            let claimObj = Claim(id: UUID(), title: title, date: date, isSolved: false)
            ClaimDao().addClaim(claimObj: claimObj)
        }
    }
    response.send("The Claim record was successfully inserted (via POST Method).")
    next()
}

Kitura.addHTTPServer(onPort: 8020, with: router)
Kitura.run()
