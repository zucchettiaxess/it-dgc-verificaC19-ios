//
//  CameraViewControllerTests.swift
//  VerifierTests
//
//

import XCTest
import UIKit
@testable import VerificaC19
import AVFoundation

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
        let viewController = CameraViewController(coder: archiver)
        XCTAssertNil(viewController)
    }
    
    func testCameraViewControllerIsLoaded() throws {
        window.makeKeyAndVisible()
        
        waitForCondition { self.controller.isViewLoaded }
    }
    
    func testCameraViewController_showPermissionsAlert() throws {
        window.makeKeyAndVisible()
        
        controller.showPermissionsAlert()
        
        waitForCondition { "alert.cameraPermissions.title".localized.isInDescendantOf(self.window) }
    }
    
    func testCameraViewController_setupLive() throws {
        window.makeKeyAndVisible()
        
        controller.setupCameraView()
        
        waitForCondition { "alert.nocamera.title".localized.isInDescendantOf(self.window) }
    }
    
    func testCameraViewController_checkPermissions() throws {
        window.makeKeyAndVisible()
        
        controller.checkPermissions(status: .authorized)
        // test passed, nothing should happen
        
        controller.checkPermissions(status: .denied)
        waitForCondition { "alert.cameraPermissions.title".localized.isInDescendantOf(self.window) }
        
    }
}
