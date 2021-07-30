//
//  CountryModel+Initials.swift
//  Verifier
//
//  Created by Andrea Prosseda on 30/07/21.
//

import SwiftDGC

extension Array where Element == CountryModel {
    
    var initials: [String] {
        map { $0.localizedName }.filter { !$0.isEmpty }.map { $0[0] }
    }
    
}
