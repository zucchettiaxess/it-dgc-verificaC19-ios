//
//  GatewayConnectionTests.swift
//  VerifierTests
//
//

import XCTest
import UIKit
import SwiftyJSON
@testable import SwiftDGC
@testable import VerificaC19

class GatewayConnectionTests: XCTestCase {
    var connection = GatewayConnection()
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
    }

    func testStart() throws {
        let exp = expectation(description: "start connection")
        connection.start { error, isVersionOutdated in
            exp.fulfill()
        }
        waitForExpectations(timeout: 20)
    }
    
    func testGetSettings() throws {
        let exp = expectation(description: "get settings")
        connection.getSettings { _ in
            exp.fulfill()
        }
        waitForExpectations(timeout: 20)
    }
    
    func testCertUpdate() throws {
        let exp = expectation(description: "get settings")
        connection.certUpdate { _, _, _ in
            exp.fulfill()
        }
        waitForExpectations(timeout: 20)
    }
    
    func testCertStatus() throws {
        let exp = expectation(description: "get settings")
        connection.certStatus(resume: "") { _ in
            exp.fulfill()
        }
        waitForExpectations(timeout: 20)
    }
}
