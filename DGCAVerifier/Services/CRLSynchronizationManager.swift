//
//  CRLSynchronizationManager.swift
//  Verifier
//
//  Created by Andrea Prosseda on 07/09/21.
//

import Foundation
import UIKit

class CRLSynchronizationManager {
    
    let AUTOMATIC_MAX_SIZE: Double = 5000
    let FIRST_CHUNK: Int = 1
    
    enum Result {
        case downloadNeeded
        case downloading
        case completed
        case paused
        case error
    }
    
    static let shared = CRLSynchronizationManager()
    
    var results: Observable<Result> { _results }
    var progress: CRLProgress? { _progress }
    
    private var gateway: GatewayConnection { GatewayConnection.shared }
    
    private let _results = Observable<Result>(nil)
    private var _serverStatus: CRLStatus?
    private var _progress: CRLProgress?
    {
        get { CRLDataStorage.shared.progress }
        set { CRLDataStorage.shared.saveProgress(newValue) }
    }
    
    
    func initialize() {
        gateway.revocationStatus(progress) { (serverStatus, error) in
            guard error == nil else { return }
            self._serverStatus = serverStatus
            self.synchronize()
        }
    }
    
    private func synchronize() {
        guard hasProgress else { return startDownload() }
        guard sameVersion else { return startDownload() }
        guard noMoreChunks else { return pauseDownload() }
        downloadCompleted()
    }
    
    func startDownload() {
        if !hasProgress { _progress = createProgress() }
        guard !requireUserInteraction else { return showAlert() }
        download()
    }
    
    func pauseDownload() {
        guard noChunksAlreadyDownloaded else { return downloadNeeded() }
        results.value = .paused
    }
    
    func downloadNeeded() {
        results.value = .downloadNeeded
    }
    
    func downloadCompleted() {
        _serverStatus = nil
        results.value = .completed
    }
    
    func cleanAndStart() {
        _progress = nil
        CRLDataStorage.clear()
        startDownload()
    }
    
    func download() {
        let mock = true //con il mock non sappiamo gestire l'allineamento col server
        guard chunksNotYetCompleted else { return mock ? downloadCompleted() : initialize() }
        results.value = .downloading
        gateway.updateRevocationList(progress) { crl, error in
            guard error == nil else { return self.errorFlow() }
            guard let crl = crl else { return self.errorFlow() }
            self.manageResponse(with: crl)
        }
    }
    
    private func manageResponse(with crl: CRL) {
//        guard isConsistent(crl) else { return startDownload() }
        CRLDataStorage.store(crl: crl)
        updateProgress(size: crl.responseSize)
        download()
    }
    
    private func errorFlow() {
        _serverStatus = nil
        _progress = nil
        results.value = .error
    }
    
    private func createProgress() -> CRLProgress {
        return .init(
            currentVersion: _serverStatus?.version ?? 0,
            totalChunks: _serverStatus?.lastChunk ?? 0,
            currentChunk: FIRST_CHUNK,
            totalSize: _serverStatus?.responseSize ?? 0,
            downloadedSize: 0
        )
    }
    
    private func updateProgress(size: Double?) {
        let progress = progress ?? createProgress()
        let current = progress.currentChunk
        let downloadedSize = progress.downloadedSize
        _progress?.currentChunk = current + 1
        _progress?.downloadedSize = downloadedSize + (size ?? 0)
    }
    
    public func showAlert() {
        let content: AlertContent = .init(
            title: "crl.update.title".localizeWith(progress!.remainingSize),
            message: "crl.update.message",
            confirmAction: { self.download() },
            confirmActionTitle: "crl.update.download.now",
            cancelAction: { self.downloadNeeded() },
            cancelActionTitle: "crl.update.try.later"
        )
        
        guard let topVC = UIApplication.topViewController() else { return }
        AppAlertViewController.present(for: topVC, with: content)
    }

}

extension CRLSynchronizationManager {
    
    private var hasProgress: Bool { _progress != nil }
    
    private var sameVersion: Bool {
        guard let localVersion = _progress?.currentVersion else { return false }
        guard let serverVersion = _serverStatus?.version else { return false }
        return localVersion == serverVersion
    }
    
    private var chunksNotYetCompleted: Bool { !noMoreChunks }
    
    private var noChunksAlreadyDownloaded: Bool { _progress?.currentChunk == FIRST_CHUNK }
    
    private var noMoreChunks: Bool {
        guard let lastChunkDownloaded = _progress?.currentChunk else { return false }
        guard let allChunks = _serverStatus?.lastChunk else { return false }
        return lastChunkDownloaded > allChunks
    }
    
    private var requireUserInteraction: Bool {
        guard let size = _serverStatus?.responseSize else { return false }
        return size > AUTOMATIC_MAX_SIZE
    }
    
    private func isConsistent(_ crl: CRL) -> Bool {
        guard let crlVersion = crl.version else { return false }
        guard let localVersion = progress?.currentVersion else { return false }
        return crlVersion == localVersion
    }
    
}
