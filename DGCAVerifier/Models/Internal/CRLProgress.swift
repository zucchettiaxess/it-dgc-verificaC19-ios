//
//  CRLProgress.swift
//  Verifier
//
//  Created by Andrea Prosseda on 07/09/21.
//

import Foundation

struct CRLProgress: Codable {
    var currentVersion: Int
    var totalChunks: Int
    var currentChunk: Int
    var totalSize: Double
    var downloadedSize: Double
    
    var remainingSize: String {
        (totalSize - downloadedSize).toMegaBytes.byteReadableValue
    }
    
    var current: Float {
        Float(currentChunk)/Float(totalChunks)
    }
    
    var chunksMessage: String {
        "crl.update.progress".localizeWith(currentChunk, totalChunks)
    }
    
    var downloadedMessage: String {
        let downloaded = downloadedSize.toMegaBytes.byteReadableValue
        let total = totalSize.toMegaBytes.byteReadableValue
        return "crl.update.progress.mb".localizeWith(downloaded, total)
    }
}
