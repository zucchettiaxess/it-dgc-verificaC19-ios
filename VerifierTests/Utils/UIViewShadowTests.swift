//
//  UtilsTests.swift
//  VerificaC19
//
//

import XCTest
@testable import VerificaC19

class UIViewShadowTests: XCTestCase {
    let view = UIView()
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
    }
    
    func testViewHelperMethods() {
        view.borderWidth = 1
        XCTAssertEqual(view.layer.borderWidth, 1)
        XCTAssertEqual(view.borderWidth, 1)
        
        view.cornerRadius = 1
        XCTAssertEqual(view.layer.cornerRadius, 1)
        XCTAssertEqual(view.cornerRadius, 1)
        
        view.layer.borderColor = nil
        XCTAssertEqual(view.borderColor, .clear)
        view.borderColor = .black
        XCTAssertEqual(view.layer.borderColor, UIColor.black.cgColor)
        XCTAssertEqual(view.borderColor, .black)
        
        view.layer.shadowColor = nil
        XCTAssertEqual(view.shadowColor, .clear)
        view.shadowColor = .black
        XCTAssertEqual(view.layer.shadowColor, UIColor.black.cgColor)
        XCTAssertEqual(view.shadowColor, .black)
        
        view.shadowRadius = 1
        XCTAssertEqual(view.layer.shadowRadius, 1)
        XCTAssertEqual(view.shadowRadius, 1)
        
        view.shadowOffset = CGSize.zero
        XCTAssertEqual(view.layer.shadowOffset, CGSize.zero)
        XCTAssertEqual(view.shadowOffset, CGSize.zero)
        
        view.shadowOpacity = 1
        XCTAssertEqual(view.layer.shadowOpacity, 1)
        XCTAssertEqual(view.shadowOpacity, 1)
    }
}
