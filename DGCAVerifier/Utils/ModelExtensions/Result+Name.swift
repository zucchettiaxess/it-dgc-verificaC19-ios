//
//  Result+Name.swift
//  Verifier
//
//  Created by Andrea Prosseda on 30/07/21.
//

import CertLogic

extension Result {
    
    var name: String {
        switch self {
        case .fail:     return "fail"
        case .open:     return "open"
        case .passed:   return "passed"
        }
    }
    
}
