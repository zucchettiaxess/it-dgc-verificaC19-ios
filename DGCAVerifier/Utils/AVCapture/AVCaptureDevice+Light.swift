//
//  AVCaptureDevice+Light.swift
//  VerificaC19
//
//  Created by Andrea Prosseda on 13/10/21.
//

import Foundation
import AVFoundation

extension AVCaptureDevice {
    
    private static var captureDevice: AVCaptureDevice? {
        AVCaptureDevice.default(for: AVMediaType.video)
    }
    
    static func switchLight() {
        guard let device = captureDevice else { return }
        enableLight(!device.isLightActive)
    }
    
    static func enableLight(_ enable: Bool) {
        guard let device = captureDevice else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            enable ? on() : off()
            device.unlockForConfiguration()
        } catch {
            print("Torch can't be used")
        }
    }
    
    private static func on() {
        guard !isLightActive else { return }
        let max = AVCaptureDevice.maxAvailableTorchLevel
        try? captureDevice?.setTorchModeOn(level: max)
    }
    
    private static func off() {
        guard isLightActive else { return }
        captureDevice?.torchMode = .off
    }
    
    var isLightActive: Bool {
        self.torchMode != .off
    }
    
    static var isLightActive: Bool {
        captureDevice?.torchMode != .off
    }
    
}
