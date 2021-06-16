//
//  CameraViewControllerTests.swift
//  VerifierTests
//
//

import XCTest
import UIKit
@testable import VerificaC19

class UIViewControllerAlertTests: XCTestCase {
    var controller: UIViewController!
    let window = UIWindow(frame: UIScreen.main.bounds)

    override func setUpWithError() throws {
        controller = UIViewController()
        window.rootViewController = controller
    }
    
    override func tearDownWithError() throws {
        window.rootViewController = nil
        window.isHidden = true
        try super.tearDownWithError()
    }
    
    func testShowAlert() throws {
        window.makeKeyAndVisible()
        
        controller.showAlert(message: "test")
            
        waitForCondition {"test".isInDescendantOf(self.window)}
    }
    
    func testShowToast() throws {
        window.makeKeyAndVisible()
        let delayExpectation = expectation(description: "Dismiss toast")

        controller.showToast(message: "test", seconds: 2.0, queue: DispatchQueue.main) {
            delayExpectation.fulfill()
        }
        
        waitForCondition {"test".isInDescendantOf(self.window)}
        
        waitForExpectations(timeout: 4)
    }
}
