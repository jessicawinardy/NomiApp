//
//  CameraPreviewView.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 15/06/26.
//

import SwiftUI
import AVFoundation
import UIKit
import SwiftData

struct CameraPreviewView: UIViewRepresentable {
    @ObservedObject var cameraEngine: CameraEngine
    
    func makeUIView(context: Context) -> UIView{
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .black
        containerView.clipsToBounds = true
        
    #if targetEnvironment(simulator)
        let imageView = UIImageView(image: UIImage(resource: .image))
        imageView.contentMode = .scaleAspectFill
        imageView.tag = 99
        containerView.addSubview(imageView)
    #else
        let previewLayer = AVCaptureVideoPreviewLayer(session: cameraEngine.session)
        previewLayer.videoGravity = .resizeAspectFill
        containerView.layer.addSublayer(previewLayer)
    #endif
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async{
        #if targetEnvironment(simulator)
            if let imageView = uiView.viewWithTag(99) as? UIImageView{
                imageView.frame = uiView.bounds
            }
        #else
            if let layer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
                layer.frame = uiView.bounds
            }
        #endif
        }
    }
}

#Preview {
    CameraView()
}
