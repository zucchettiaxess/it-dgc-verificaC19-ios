//
//  CameraViewControllerTests.swift
//  VerifierTests
//
//  Created by Alex Paduraru on 14.06.2021.
//

import XCTest
import UIKit
@testable import VerificaC19

class CameraViewControllerTests: XCTestCase {
    var controller: CameraViewController!
    let window = UIWindow(frame: UIScreen.main.bounds)

    override func setUpWithError() throws {
        let coordinator: CameraCoordinator = MainCoordinator(navigationController: UINavigationController())
        controller = CameraViewController(coordinator: coordinator)
        window.rootViewController = controller
    }
    
    override func tearDownWithError() throws {
        window.rootViewController = nil
        window.isHidden = true
        try super.tearDownWithError()
    }
        
    func testInitWithCoder() {
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)
        let viewController = HomeViewController(coder: archiver)
        XCTAssertNil(viewController)
    }
    
    func testCameraViewControllerIsLoaded() throws {
        window.makeKeyAndVisible()
        
        waitForCondition { self.controller.isViewLoaded }
    }
}
