//
//  GatewayConnectionTests.swift
//  VerifierTests
//
//

import XCTest
import UIKit
import SwiftyJSON
import Alamofire
@testable import SwiftDGC
@testable import VerificaC19

class GatewayConnectionTests: XCTestCase {
    var mockConnection: GatewayConnection!
    var liveConnection: GatewayConnection!
    
    // MARK: Setup and Teardown
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let session = Session(configuration: configuration)
        
        mockConnection = GatewayConnection(session: session)
        
        liveConnection = GatewayConnection()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testLiveStart() throws {
        let exp = expectation(description: "start connection")
        liveConnection.start { error, isVersionOutdated in
            exp.fulfill()
        }
        waitForExpectations(timeout: 20)
    }
    
    func testLiveGetSettings() throws {
        let exp = expectation(description: "get settings")
        liveConnection.getSettings { _ in
            exp.fulfill()
        }
        waitForExpectations(timeout: 20)
    }
    
    func testLiveCertUpdate() throws {
        let exp = expectation(description: "get settings")
        liveConnection.certUpdate { _, _, _ in
            exp.fulfill()
        }
        waitForExpectations(timeout: 20)
    }
    
    func testLiveCertStatus() throws {
        let exp = expectation(description: "get settings")
        liveConnection.certStatus(resume: "") { _ in
            exp.fulfill()
        }
        waitForExpectations(timeout: 20)
    }
    
    // MARK: Mocks
    
    func testMockStart() throws {
        let exp = expectation(description: "start connection")
        LocalData.sharedInstance.resumeToken = nil
        mockConnection.start { error, isVersionOutdated in
            exp.fulfill()
        }
        waitForExpectations(timeout: 20)
    }

    
    func testMockUpdateRequest() {
        
        let exp = expectation(description: "Mock Update Request")
        
        mockConnection.certUpdate { encodedCert, token, error in
            XCTAssertEqual(token, "1")
            XCTAssertNil(error)
            
            XCTAssertEqual(Mocks.mocks[Mocks.updateKey], encodedCert)
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 20)
    }
    
    func testMockStatusRequest() {
        
        let exp = expectation(description: "Mock Status Request")
        
        mockConnection.certStatus { kid in
            
            XCTAssertEqual(kid?.first, "+/bbaA9m0j0=")
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 20)
    }

    func testMockSettingsRequest() {
        
        let exp = expectation(description: "Mock Settings Request")
        
        mockConnection.getSettings { settings in
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 20)
    }
    
}
