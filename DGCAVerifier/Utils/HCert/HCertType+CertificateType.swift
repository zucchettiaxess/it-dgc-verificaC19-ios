//
//  HCertType+CertificateType.swift
//  Verifier
//
//  Created by Andrea Prosseda on 27/07/21.
//

import Foundation
import SwiftDGC
import CertLogic

extension SwiftDGC.HCertType {
    
    var certificateType: CertificateType {
        switch self {
        case .test:         return .test
        case .vaccine:      return .vaccination
        case .recovery:     return .recovery
        default:            return .general
        }
    }
    
}
