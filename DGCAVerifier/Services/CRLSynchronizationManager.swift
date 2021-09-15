//
//  CRLSynchronizationManager.swift
//  Verifier
//
//  Created by Andrea Prosseda on 07/09/21.
//

import Foundation
import UIKit

protocol CRLSynchronizationDelegate {
    func statusDidChange(with result: CRLSynchronizationManager.Result)
}

class CRLSynchronizationManager {
    
    let AUTOMATIC_MAX_SIZE: Double = 5.0.fromMegaBytesToBytes
    
    enum Result {
        case downloadReady
        case downloading
        case completed
        case paused
        case error
    }
    
    static let shared = CRLSynchronizationManager()
    
    var progress: CRLProgress { _progress }
    var gateway: GatewayConnection { GatewayConnection.shared }
    
    private var _delegate: CRLSynchronizationDelegate?
    private var _serverStatus: CRLStatus?
    private var _progress: CRLProgress
    {
        get { CRLDataStorage.shared.progress ?? .init() }
        set { CRLDataStorage.shared.saveProgress(newValue) }
    }
    
    func initialize(delegate: CRLSynchronizationDelegate? = nil) {
        log("initialize")
        self._delegate = delegate
        gateway.revocationStatus(progress) { (serverStatus, error) in
            guard error == nil else { return }
            self._serverStatus = serverStatus
            self.synchronize()
        }
    }
    
    private func synchronize() {
        log("start synchronization")
        guard outdatedVersion else { return downloadCompleted() }
        guard noPendingDownload else { return resumeDownload() }
        startDownload()
    }
        
    func startDownload() {
        _progress = CRLProgress(serverStatus: _serverStatus)
        guard !requireUserInteraction else { return showAlert() }
        download()
    }
    
    func resumeDownload() {
        log("resuming previous progress")
        guard sameChunkSize else { return cleanAndRetry() }
        guard sameRequestedVersion else { return cleanAndRetry() }
        guard oneChunkAlreadyDownloaded else { return readyToDownload() }
        readyToResume()
    }
    
    func readyToDownload() {
        log("user can download")
        _delegate?.statusDidChange(with: .downloadReady)
    }
    
    func readyToResume() {
        log("user can resume download")
        _delegate?.statusDidChange(with: .paused)
    }
    
    func downloadCompleted() {
        log("version up to date")
        completeProgress()
        _serverStatus = nil
        _delegate?.statusDidChange(with: .completed)
    }
    
    func cleanAndRetry() {
        log("clean needed, retry")
        _progress = .init()
        _serverStatus = nil
        CRLDataStorage.clear()
        initialize()
    }
    
    func download() {
//        quando sarà tolto mock
//        guard chunksNotYetCompleted else { return initialize() }
        guard chunksNotYetCompleted else { return downloadCompleted() }
        log(progress)
        _delegate?.statusDidChange(with: .downloading)
        gateway.updateRevocationList(progress) { crl, error in
            guard error == nil else { return self.errorFlow() }
            guard let crl = crl else { return self.errorFlow() }
            self.manageResponse(with: crl)
        }
    }
    
    private func manageResponse(with crl: CRL) {
        guard isConsistent(crl) else { return cleanAndRetry() }
        log("managing response")
        CRLDataStorage.store(crl: crl)
        updateProgress(with: crl.responseSize)
        download()
    }
    
    private func errorFlow() {
        _serverStatus = nil
        _delegate?.statusDidChange(with: .error)
    }
        
    private func updateProgress(with size: Double?) {
        let current = progress.currentChunk ?? CRLProgress.FIRST_CHUNK
        let downloadedSize = progress.downloadedSize ?? 0
        _progress.currentChunk = current + 1
        _progress.downloadedSize = downloadedSize + (size ?? 0)
    }
    
    private func completeProgress() {
        let completedVersion = progress.requestedVersion
        _progress = .init(version: completedVersion)
    }
    
    public func showAlert() {
        let content: AlertContent = .init(
            title: "crl.update.title".localizeWith(progress.remainingSize),
            message: "crl.update.message",
            confirmAction: { self.download() },
            confirmActionTitle: "crl.update.download.now",
            cancelAction: { self.readyToDownload() },
            cancelActionTitle: "crl.update.try.later"
        )
        
        guard let topVC = UIApplication.topViewController() else { return }
        AppAlertViewController.present(for: topVC, with: content)
    }

}

extension CRLSynchronizationManager {
        
    private var noPendingDownload: Bool {
        progress.currentVersion == progress.requestedVersion
    }
    
    private var outdatedVersion: Bool {
        _serverStatus?.version != _progress.currentVersion
    }
    
    private var sameRequestedVersion: Bool {
        _serverStatus?.version == _progress.requestedVersion
    }
    
    private var chunksNotYetCompleted: Bool { !noMoreChunks }
    
    private var noMoreChunks: Bool {
        guard let lastChunkDownloaded = _progress.currentChunk else { return false }
        guard let allChunks = _serverStatus?.lastChunk else { return false }
        return lastChunkDownloaded > allChunks
    }
    
    private var oneChunkAlreadyDownloaded: Bool {
        guard let currentChunk = _progress.currentChunk else { return true }
        return currentChunk > CRLProgress.FIRST_CHUNK
    }

    private var sameChunkSize: Bool {
        guard let localChunkSize = _progress.chunkSize else { return false }
        guard let serverChunkSize = _serverStatus?.chunkSize else { return false }
        return localChunkSize == serverChunkSize
    }
    
    private var requireUserInteraction: Bool {
        guard let size = _serverStatus?.responseSize else { return false }
        return size > AUTOMATIC_MAX_SIZE
    }

    private func isConsistent(_ crl: CRL) -> Bool {
        guard let crlVersion = crl.version else { return false }
        return crlVersion == progress.requestedVersion
    }
    
    private func log(_ message: String) {
        print("log.crl.sync - " + message)
    }
    
    private func log(_ progress: CRLProgress) {
        let from = progress.currentVersion
        let to = progress.requestedVersion
        let chunk = progress.currentChunk ?? CRLProgress.FIRST_CHUNK
        let chunks = progress.totalChunks ?? CRLProgress.FIRST_CHUNK
        log("downloading [\(from)->\(to)] \(chunk)/\(chunks)")
    }
}
