//
//  CameraViewControllerTests.swift
//  VerifierTests
//
//  Created by Alex Paduraru on 14.06.2021.
//

import XCTest
import UIKit
@testable import VerificaC19

class HomeViewControllerTests: XCTestCase {
    let viewModel = HomeViewModel()
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
    
    func testHomeViewController_showOutdatedAlert() throws {
        window.makeKeyAndVisible()
        
        viewModel.isVersionOutdated.value = true
        waitForCondition { "alert.versionOutdated.title".localized.isInDescendantOf(self.window) }
    }
    
    func testHomeViewController_showLoadingActivity() throws {
        window.makeKeyAndVisible()
        
        viewModel.isLoading.value = true
        waitForCondition { self.controller.loadingActivityView.isAnimating == true }
    }
}
