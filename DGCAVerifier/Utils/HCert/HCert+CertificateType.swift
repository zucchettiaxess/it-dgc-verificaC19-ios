//
//  HCert+CertificateType.swift
//  Verifier
//
//  Created by Andrea Prosseda on 30/07/21.
//

import Foundation
import SwiftDGC
import CertLogic

extension HCert {
    
    var certificateType: CertificateType {
        switch type {
        case .test:         return .test
        case .vaccine:      return .vaccination
        case .recovery:     return .recovery
        default:            return .general
        }
    }
    
}
