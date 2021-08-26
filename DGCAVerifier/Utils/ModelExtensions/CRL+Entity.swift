//
//  CRL+Entity.swift
//  Verifier
//
//  Created by Andrea Prosseda on 25/08/21.
//

import Foundation

extension CRL {
    
    var isSnapshot: Bool { !(revokedUcvi ?? []).isEmpty }
    
    var isDelta: Bool { delta != nil }
    
}
