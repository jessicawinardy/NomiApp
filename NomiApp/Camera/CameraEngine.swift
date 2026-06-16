//
//  CameraEngine.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 15/06/26.
//

import SwiftUI
import Combine
import AVFoundation
import UIKit

class CameraEngine: NSObject, ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var image: UIImage? = nil
    
    private let output = AVCapturePhotoOutput()
    private var videoDeviceInput: AVCaptureDeviceInput?
    
    private var isUsingFrontCamera = false
    private var flashMode: AVCaptureDevice.FlashMode = .off
    
    override init() {
        super.init()
        checkPermissions()
    }
    
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.setupSession()
                    }
                }
            }
            default:
                break
        }
    }
    
    private func setupSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return
        }
        
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: backCamera)
            
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            }
            
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        
        session.commitConfiguration()
        
    }
    
    func captureImage() {
        let settings = AVCapturePhotoSettings()
        
    #if targetEnvironment(simulator)
        print("Running in Simulator")
        self.image = UIImage(resource: .image)
    #else
        if let device = videoDeviceInput?.device, device.hasFlash {
            settings.flashMode = self.flashMode
        }
        
        output.capturePhoto(with: settings, delegate: self)
    #endif
    }
    
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    
    func flipCamera() {
        guard let currentInput = videoDeviceInput else { return }
        session.beginConfiguration()
        
        session.removeInput(currentInput)
        
        isUsingFrontCamera.toggle()
        
        let newPosition: AVCaptureDevice.Position = isUsingFrontCamera ? .front : .back
        
        if let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition),
           let newInput = try? AVCaptureDeviceInput(device: newDevice),
           session.canAddInput(newInput){
            session.addInput(newInput)
            videoDeviceInput = newInput
        } else {
            session.addInput(currentInput)
        }
        session.commitConfiguration()
            
        }
    
    func toggleFlash() -> String{
        switch flashMode {
        case .off:
            flashMode = .on
            return "bolt.fill"
        case .on:
            flashMode = .auto
            return "bolt.badge.a.fill"
        case .auto:
            flashMode = .off
            return "bolt.slash.fill"
        @unknown default:
            flashMode = .off
            return "bolt.slash.fill"
        }
    }
    
    func startSession() {
        guard !session.isRunning else {return}
        sessionQueue.async{
            self.session.startRunning()
        }
    }
    
    func stopSession(){
        guard session.isRunning else {return}
        sessionQueue.async{
            self.session.stopRunning()
        }
    }
}

extension CameraEngine: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil,
              let safeData = photo.fileDataRepresentation(),
              let capturedImage = UIImage(data: safeData)
        else {
            print("Error Capturing Image")
            return
        }
        DispatchQueue.main.async {
            self.image = capturedImage
        }
    }
}
