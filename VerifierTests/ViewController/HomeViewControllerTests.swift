//
//  CameraViewControllerTests.swift
//  VerifierTests
//
//

import XCTest
import UIKit
@testable import VerificaC19

class HomeViewControllerTests: XCTestCase {
    let viewModel = MockHomeViewModel()
    let localData = LocalData()
    var controller: HomeViewController!
    let window = UIWindow(frame: UIScreen.main.bounds)

    override func setUpWithError() throws {
        let coordinator: HomeCoordinator = MainCoordinator(navigationController: UINavigationController())
        
        controller = HomeViewController(coordinator: coordinator, viewModel: viewModel)
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
    
    func testHomeViewControllerIsLoaded() throws {
        window.makeKeyAndVisible()
        
        waitForCondition { self.controller.isViewLoaded }
    }
    
    func testHomeViewController_isVersionOutdated() throws {
        viewModel.isVersionOutdated.value = false
        window.makeKeyAndVisible()
        controller.loadViewIfNeeded()
        
        viewModel.isVersionOutdated.value = true
        waitForCondition { "alert.versionOutdated.title".localized.isInDescendantOf(self.window) }
    }
    
    func testHomeViewController_showLoadingActivity() throws {
        window.makeKeyAndVisible()
        
        viewModel.isLoading.value = true
        waitForCondition { self.controller.loadingActivityView.isAnimating == true }
    }
    
    func testHomeViewController_lastUpdateText() throws {
        window.makeKeyAndVisible()
        
        viewModel.lastUpdateText.value = "Test date"
        waitForCondition { "Test date".isInDescendantOf(self.window) }
    }
        
    func testHomeViewController_isScanEnabled() throws {
        window.makeKeyAndVisible()
        
        viewModel.isScanEnabled.value = true
        waitForCondition { self.controller.scanButton.isEnabled }
    }
    
    func testHomeViewController_noKeyslert() throws {
        viewModel.isScanEnabled.value = true
        LocalData.sharedInstance.lastFetch = Date(timeIntervalSince1970: 0)
        
        window.makeKeyAndVisible()
        controller.loadViewIfNeeded()
        
        if controller.scanButton.tap() {
            waitForCondition { "alert.noKeys.title".localized.isInDescendantOf(self.window) }
        }
    }
    
    func testHomeViewController_versionOutdatedAlert() throws {
        viewModel.isScanEnabled.value = true
        LocalData.sharedInstance.lastFetch = Date()
        
        window.makeKeyAndVisible()
        controller.loadViewIfNeeded()
        
        viewModel.isVersionOutdated.value = true
        if controller.scanButton.tap() {
            waitForCondition { "alert.versionOutdated.title".localized.isInDescendantOf(self.window) }
        }
    }
    
    func testHomeViewController_scanAction() throws {
        viewModel.isScanEnabled.value = true
        LocalData.sharedInstance.lastFetch = Date(timeIntervalSince1970: 0)
        
        window.makeKeyAndVisible()
        controller.loadViewIfNeeded()
        
        if controller.scanButton.tap() {
            waitForCondition { "alert.noKeys.title".localized.isInDescendantOf(self.window) }
        }
    }
}
