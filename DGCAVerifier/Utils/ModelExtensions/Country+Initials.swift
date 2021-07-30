//
//  Country+Initials.swift
//  Verifier
//
//  Created by Andrea Prosseda on 28/07/21.
//

import Foundation

extension Array where Element == Country {
    var initials: [String] { compactMap { $0.name?[0] } }
}
