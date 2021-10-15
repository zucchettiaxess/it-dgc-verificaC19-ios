/*
 *  license-start
 *  
 *  Copyright (C) 2021 Ministero della Salute and all other contributors
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
*/

//
//  HomeViewController.swift
//  dgp-whitelabel-ios
//
//

import UIKit
import Vision
import AVFoundation
import SwiftDGC

protocol CameraCoordinator: Coordinator {
    func validate(payload: String, country: CountryModel?, delegate: CameraDelegate)
}

protocol CameraDelegate {
    func startRunning()
    func stopRunning()
    func setupFlash()
}

let mockQRCode = "<add your mock qr code here>"

class CameraViewController: UIViewController {
    weak var coordinator: CameraCoordinator?
    private var country: CountryModel?
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var backButton: AppButton!
    @IBOutlet weak var countryButton: AppButton!
    @IBOutlet weak var flashButton: AppButton!  
    @IBOutlet weak var switchButton: UIButton!

    private var captureSession = AVCaptureSession()
    private let allowedCodes: [VNBarcodeSymbology] = [.qr, .aztec]
    private let scanConfidence: VNConfidence = 0.9
    
    // MARK: - Init
    init(coordinator: CameraCoordinator, country: CountryModel? = nil) {
        self.coordinator = coordinator
        self.country = country

        super.init(nibName: "CameraViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeBackButton()
        initializeFlashButton()
        initializeCountryButton()
        #if targetEnvironment(simulator)
        found(payload: mockQRCode)
        #else
        checkPermissions()
        setupCameraView()
        #endif
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopRunning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startRunning()
        setupFlash()
    }

    @IBAction func back(_ sender: Any) {
        coordinator?.dismiss()
    }
    
    @IBAction func flashSwitch(_ sender: Any) {
        AVCaptureDevice.switchTorch()
        Store.set(AVCaptureDevice.isTorchActive, for: .isTorchActive)
    }
    
    @IBAction func backToRoot(_ sender: Any) {
        coordinator?.dismissToRoot()
    }

    @IBAction func switchCamera(_ sender: Any) {
        let frontCameraActive = Store.getBool(key: .isFrontCameraActive)
        Store.set(!frontCameraActive, for: .isFrontCameraActive)
        flashButton.isHidden = !frontCameraActive
        
        setupCameraView()
        startRunning()
        setupFlash()
    }
    
    private func found(payload: String) {
        let vc = coordinator?.navigationController.visibleViewController
        guard !(vc is VerificationViewController) else { return }
        stopRunning()
        hapticFeedback()
        coordinator?.validate(payload: payload, country: country, delegate: self)
    }
    
    private func initializeBackButton() {
        backButton.style = .minimal
        backButton.setLeftImage(named: "icon_back")
    }
    
    private func initializeFlashButton() {
        flashButton.cornerRadius = 30.0
        flashButton.backgroundColor = .clear
        flashButton.setImage(UIImage(named: "flash-camera"))
        flashButton.isHidden = Store.getBool(key: .isFrontCameraActive)
    }
    
    private func initializeCountryButton() {
        countryButton.style = .white
        countryButton.setRightImage(named: "icon_arrow-right")
        countryButton.setTitle(country?.name)
        countryButton.isHidden = country == nil
    }
    
    private func initializeCamSwitchButton() {
        switchButton.cornerRadius = 30.0
        switchButton.backgroundColor = .clear
        switchButton.tintColor = UIColor.white
        switchButton.setImage(UIImage(named: "switch-camera"))
    }

    // MARK: - Permissions

    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard !granted else { return }
                self?.showPermissionsAlert()
            }
        case .denied, .restricted:
            self.showPermissionsAlert()
        default:
            return
        }
    }
    
    private func showPermissionsAlert() {
        self.showAlert(withTitle: "alert.camera.permissions.title".localized,
                       message: "alert.camera.permissions.message".localized)
    }

    // MARK: - Setup
    private func setupCameraView() {
        cameraView.layer.backgroundColor = Palette.grayDark.cgColor
        cleanSession()
        let isFrontCamera = Store.getBool(key: .isFrontCameraActive)
        let cameraMode: AVCaptureDevice.Position = isFrontCamera ? .front : .back
    
        let input = getCameraInput(mode: cameraMode, for: captureSession)
        let output = getCaptureOutput()
        let layer = getCameraPreviewLayer(for: captureSession)
        
        guard let cameraInput = input else { return noCameraError() }
        captureSession.sessionPreset = .hd1280x720
        captureSession.addInput(cameraInput)
        captureSession.addOutput(output)
        cameraView.layer.insertSublayer(layer, at: 0)
    }
    
    private func cleanSession() {
        stopRunning()
        cameraView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        captureSession.inputs.forEach { captureSession.removeInput($0) }
        captureSession.outputs.forEach { captureSession.removeOutput($0) }
    }
    
    private func getCameraInput(mode: AVCaptureDevice.Position, for session: AVCaptureSession) -> AVCaptureDeviceInput? {
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: mode)
        
        guard let device = videoDevice else { return nil }
        let deviceInput = try? AVCaptureDeviceInput(device: device)
        guard let input = deviceInput else { return nil }
        guard session.canAddInput(input) else { return nil }
        return input
    }
    
    private func getCaptureOutput() -> AVCaptureVideoDataOutput {
        let captureOutput = AVCaptureVideoDataOutput()
        captureOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        return captureOutput
    }
    
    private func getCameraPreviewLayer(for session: AVCaptureSession) -> AVCaptureVideoPreviewLayer {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraPreviewLayer.videoGravity = .resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = .portrait
        cameraPreviewLayer.frame = view.frame
        return cameraPreviewLayer
    }
    private func noCameraError() {
        showAlert(withTitle: "alert.nocamera.title".localized, message: "alert.nocamera.message".localized)
    }
    
    private func setupBackCamera() {
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .hd1280x720
        let isFrontCameraActive = Store.getBool(key: .isFrontCameraActive)
        let cameraMode: AVCaptureDevice.Position = isFrontCameraActive ? .front : .back
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraMode)
        
        guard let device = videoDevice, let videoDeviceInput = try? AVCaptureDeviceInput(device: device),
              captureSession.canAddInput(videoDeviceInput) else {
                  self.showAlert(withTitle: "alert.nocamera.title".localized, message: "alert.nocamera.message".localized)
                  return
              }
        captureSession.addInput(videoDeviceInput)
        
            // Camera output.
        let captureOutput = AVCaptureVideoDataOutput()
        captureOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        captureSession.addOutput(captureOutput)
        
            // Camera preview layer
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.videoGravity = .resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = .portrait
        cameraPreviewLayer.frame = view.frame
        cameraView.layer.insertSublayer(cameraPreviewLayer, at: 0)
        captureSession.commitConfiguration()
    }
    
    private func hapticFeedback() {
        DispatchQueue.main.async {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
    
}

extension CameraViewController: CameraDelegate {
    func startRunning() {
        #if targetEnvironment(simulator)
        back(self)
        #else
        guard !captureSession.isRunning else { return }
        captureSession.startRunning()
        #endif
    }
    
    func stopRunning() {
        guard captureSession.isRunning else { return }
        captureSession.stopRunning()
    }
    
    func setupFlash() {
        let torchActive = Store.getBool(key: .isTorchActive)
        let frontCamera = Store.getBool(key: .isFrontCameraActive)
        let enable = torchActive && !frontCamera
        AVCaptureDevice.enableTorch(enable)
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right)
        let detectBarcodeRequest = VNDetectBarcodesRequest { [weak self] request, error in
            guard error == nil else {
                self?.showAlert(withTitle: "alert.barcode.error.title".localized, message: error?.localizedDescription ?? "error")
                return
            }

            self?.processBarcodesRequest(request)
        }

        do {
            try imageRequestHandler.perform([detectBarcodeRequest])
        } catch {
            print(error)
        }
    }

    func processBarcodesRequest(_ request: VNRequest) {
        guard let barcodes = request.results else { return }

        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.cameraView.layer.sublayers?.removeSubrange(1...)

            if self.captureSession.isRunning {
                for barcode in barcodes {
                    guard let potentialQRCode = barcode as? VNBarcodeObservation,
                          self.allowedCodes.contains(potentialQRCode.symbology),
                          potentialQRCode.confidence > self.scanConfidence else { return }

                    self.found(payload: potentialQRCode.payloadStringValue ?? "")
                }
            }
        }
    }
}
