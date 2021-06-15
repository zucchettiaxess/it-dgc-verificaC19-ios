//
//  UtilsTests.swift
//  VerificaC19
//
//  Created by Alex Paduraru on 14.06.2021.
//

import XCTest
@testable import VerificaC19

class ObservableTests: XCTestCase {
    var observable = Observable("test")
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testAddRemove() {
        var testedValue: String? = "updatedTest"
        
        observable.add(observer: self) { value in
            testedValue = value
        }
        observable.value = "updatedTest"
        XCTAssertEqual(testedValue, "updatedTest")
    
        observable.remove(observer: self)
        
        observable.value = "test"
        XCTAssertEqual(observable.value, "test")
        XCTAssertEqual(testedValue, "updatedTest")
    }
}
