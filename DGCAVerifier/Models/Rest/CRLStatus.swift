//
//  CRLStatus.swift
//  Verifier
//
//  Created by Andrea Prosseda on 07/09/21.
//

import Foundation

struct CRLStatus: Codable {
    var id: String?
    var fromVersion: Int?
    var version: Int?
    var chunkSize: Int?
    var lastChunk: Int?
    var responseSize: Double?
    var numAddItems: Int?
    var numRemoveItems: Int?
    
}
