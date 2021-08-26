//
//  CRL.swift
//  Verifier
//
//  Created by Andrea Prosseda on 25/08/21.
//

import Foundation

struct CRL: Codable {
    var id: String?
    var version: Int?
    var revokedUcvi: [String]?
    var delta: Delta?
    var creationDate: String?
}
