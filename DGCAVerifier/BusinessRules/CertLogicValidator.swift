//
//  CertLogicValidator.swift
//  Verifier
//
//  Created by Andrea Prosseda on 28/07/21.
//

import Foundation
import SwiftDGC
import CertLogic

struct CertLogicValidator: Validator {

    static let defaultCode = "IT"
    static var manager: CertLogicEngineManager { CertLogicEngineManager.sharedInstance }

    static func getStatus(from hCert: HCert) -> Status {
        return .valid
    }

}
