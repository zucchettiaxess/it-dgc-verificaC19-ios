//
//  CameraViewControllerTests.swift
//  VerifierTests
//
//  Created by Alex Paduraru on 14.06.2021.
//

import XCTest
import UIKit
@testable import VerificaC19

class ResultViewTests: XCTestCase {
    var resultView: ResultView?
    
    override func setUpWithError() throws {
        resultView = Bundle.main.loadNibNamed("ResultView", owner: nil, options: nil)?.first as? ResultView
    }
    
    override func tearDownWithError() throws {
    }
    
    func testResultView() throws {
        let resultItem = ResultItem(title: "Title", subtitle: "Subtitle", imageName: nil)
        resultView?.configure(with: resultItem)
        
        XCTAssertEqual(resultView?.titleLabel.text, "Title")
        XCTAssertEqual(resultView?.subtitleLabel.text, "Subtitle")
        XCTAssertNil(resultView?.iconImageView.image)
        
        //The Bundle for your current class
    
        let image = UIImage(named: "icon_close")
        let resultItem2 = ResultItem(title: "Title", subtitle: "Subtitle", imageName: "icon_close")
        resultView?.configure(with: resultItem2)
        XCTAssertEqual(resultView?.iconImageView.image, image)
    }}
