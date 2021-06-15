//
//  CameraViewControllerTests.swift
//  VerifierTests
//
//  Created by Alex Paduraru on 14.06.2021.
//

import XCTest
import UIKit
@testable import VerificaC19

class MainCoordinatorTests: XCTestCase {
    var coordinator = MainCoordinator(navigationController: UINavigationController())
    let window = UIWindow(frame: UIScreen.main.bounds)

    override func setUpWithError() throws {
        window.rootViewController = coordinator.navigationController
    }
    
    override func tearDownWithError() throws {
        window.rootViewController = nil
        window.isHidden = true
        try super.tearDownWithError()
    }
    
    func testCoordinator() throws {
        window.makeKeyAndVisible()
        
        coordinator.start()
        waitForCondition { (self.window.rootViewController as! UINavigationController).viewControllers.first is HomeViewController }
        
        coordinator.showCamera()
        waitForCondition { (self.window.rootViewController as! UINavigationController).viewControllers.last is CameraViewController }
        
        coordinator.dismissCamera()
        waitForCondition { !((self.window.rootViewController as! UINavigationController).viewControllers.last is CameraViewController) }
                        
        coordinator.showVerificationFor(payloadString: "testQRCode")
        waitForCondition { (self.window.rootViewController as! UINavigationController).presentedViewController is VerificationViewController }
        
        coordinator.dismissVerification()
        waitForCondition { !((self.window.rootViewController as! UINavigationController).presentedViewController is VerificationViewController) }
    }
}
