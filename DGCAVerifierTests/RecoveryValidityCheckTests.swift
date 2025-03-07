/*
 *  license-start
 *  
 *  Copyright (C) 2021 Ministero della Salute and all other contributors
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
*/

//
//  RecoveryValidityCheckTest.swift
//  VerifierTests
//
//  Created by Davide Aliti on 08/06/21.
//

import XCTest
@testable import VerificaC19
@testable import SwiftDGC
import SwiftyJSON

class RecoveryValidityCheckTest: XCTestCase {
    var recoveryValidityCheck: RecoveryValidityCheck!
    var hcert: HCert!
    var payload: String!
    var bodyString: String!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        recoveryValidityCheck = RecoveryValidityCheck()
        payload = "HC1:6BFOXN%TS3DHPVO13J /G-/2YRVA.Q/R8WRU2FCAH9BDF%188WA.*RXU7IJ6W*PP+PDPIGOK-*GN*Q:XJR-GM%O-RQOTAF/8X*G3M9FQH+4J/-K$+CY73JC3MD3IFTKJ3SZ4P:45/GZW4:.AY731MF7FN6LBHKBCAJPF71M3.FJZIJ09B*KNQ579PJMD3+476J3:NB3N5XW49+20CMAHLW 70SO:GOLIROGOAQ5ZU4RKCSHGX2M5C9HHB%LGJZII7JSTNCA7G6MXYQYYQQKRM64YVQB95326FW4AJOMKMV35U:7-Z7QT499RLHPQ15O+4/Z6E 6U963X7$8Q$HMCP63HU$*GT*Q3-Q4+O7F6E%CN4D74DWZJ$7K+ CZEDB2M$9C1QD7+2*KUQFCOYA73A-MG*VM%UUY$MW5LM+GW*1.Q5$Y7M-FSYLJF3*TRJY9R.8VBQA65%UVLXFTYVN T$WM3 UJ16F:S0CLRVJAD7KOB1GV+20RT8S0"
        hcert = HCert(from: payload)
        bodyString = "{\"1\": \"Ministero della Salute\", \"4\": 1623317503, \"6\": 1620925550, \"-260\": {\"1\": {\"r\": [{\"du\": \"2021-10-31\", \"ci\": \"01ITF59E8461C316424486E4A96E10CC039C#6\", \"tg\": \"840539006\", \"is\": \"Ministero della Salute\", \"df\": \"2021-05-04\", \"fr\": \"2021-05-02\", \"co\": \"IT\"}], \"dob\": \"1977-06-16\", \"nam\": {\"gnt\": \"MARILU<TERESA\", \"fnt\": \"DI<CAPRIO\", \"fn\": \"Di Caprio\", \"gn\": \"Marilù Teresa\"}, \"ver\": \"1.0.0\"}}}"
        SettingDataStorage.sharedInstance.settings = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        recoveryValidityCheck = nil
        payload = nil
        hcert = nil
        bodyString = nil
        SettingDataStorage.sharedInstance.settings = []
    }

    func testValidRecoveryDate() {
        let recoverySettingStartDay = Setting(name: "recovery_cert_start_day", type: "GENERIC", value: "0")
        let recoverySettingEndDay = Setting(name: "recovery_cert_end_day", type: "GENERIC", value: "1")
        SettingDataStorage.sharedInstance.addOrUpdateSettings(recoverySettingStartDay)
        SettingDataStorage.sharedInstance.addOrUpdateSettings(recoverySettingEndDay)
        let todayDate : Date = Date()
        let todayDateFormatted = todayDate.toDateString
        let futureDate = Calendar.current.date(byAdding: .day, value: 2, to: todayDate)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let futureDateFormatted = dateFormatter.string(from: futureDate)
        bodyString = bodyString.replacingOccurrences(of: "\"df\": \"2021-05-04\"", with: "\"df\": \"\(todayDateFormatted)\"")
        bodyString = bodyString.replacingOccurrences(of: "\"du\": \"2021-10-31\"", with: "\"du\": \"\(futureDateFormatted)\"")
        hcert.body = JSON(parseJSON: bodyString)[ClaimKey.hCert.rawValue][ClaimKey.euDgcV1.rawValue]
        let isRecoveryDateValidResult = recoveryValidityCheck.isRecoveryValid(hcert)
        
        XCTAssertEqual(isRecoveryDateValidResult, .valid)
    }
    
    func testValidPartiallyRecoveryDate() {
        let recoverySettingStartDay = Setting(name: "recovery_cert_start_day", type: "GENERIC", value: "0")
        let recoverySettingEndDay = Setting(name: "recovery_cert_end_day", type: "GENERIC", value: "7")
        SettingDataStorage.sharedInstance.addOrUpdateSettings(recoverySettingStartDay)
        SettingDataStorage.sharedInstance.addOrUpdateSettings(recoverySettingEndDay)
        let todayDate : Date = Date()
        let pastDfDate = Calendar.current.date(byAdding: .day, value: -5, to: todayDate)!
        let pastDuDate = Calendar.current.date(byAdding: .day, value: -1, to: todayDate)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let pastDfDateFormatted = dateFormatter.string(from: pastDfDate)
        let pastDuDateFormatted = dateFormatter.string(from: pastDuDate)
        bodyString = bodyString.replacingOccurrences(of: "\"df\": \"2021-05-04\"", with: "\"df\": \"\(pastDfDateFormatted)\"")
        bodyString = bodyString.replacingOccurrences(of: "\"du\": \"2021-10-31\"", with: "\"du\": \"\(pastDuDateFormatted)\"")
        hcert.body = JSON(parseJSON: bodyString)[ClaimKey.hCert.rawValue][ClaimKey.euDgcV1.rawValue]
        let isRecoveryDateValidResult = recoveryValidityCheck.isRecoveryValid(hcert)
        
        XCTAssertEqual(isRecoveryDateValidResult, .validPartially)
    }
    
    func testFutureRecoveryDate() {
        let recoverySettingStartDay = Setting(name: "recovery_cert_start_day", type: "GENERIC", value: "0")
        let recoverySettingEndDay = Setting(name: "recovery_cert_end_day", type: "GENERIC", value: "1")
        SettingDataStorage.sharedInstance.addOrUpdateSettings(recoverySettingStartDay)
        SettingDataStorage.sharedInstance.addOrUpdateSettings(recoverySettingEndDay)
        let todayDate : Date = Date()
        let futureDate = Calendar.current.date(byAdding: .day, value: 2, to: todayDate)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let futureDateFormatted = dateFormatter.string(from: futureDate)
        bodyString = bodyString.replacingOccurrences(of: "\"df\": \"2021-05-04\"", with: "\"df\": \"\(futureDateFormatted)\"")
        hcert.body = JSON(parseJSON: bodyString)[ClaimKey.hCert.rawValue][ClaimKey.euDgcV1.rawValue]
        let isRecoveryDateValidResult = recoveryValidityCheck.isRecoveryValid(hcert)
        
        XCTAssertEqual(isRecoveryDateValidResult, .notValidYet)
    }
    
}
