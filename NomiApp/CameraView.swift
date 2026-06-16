//
//  CameraView.swift
//  NomiApp
//
//  Created by Jessica Evangeline Winardy on 11/06/26.
//

import SwiftUI
import UIKit

struct CameraView: View {
    @StateObject private var cameraEngine = CameraEngine()
    @State private var flashIcon = "bolt.slash.fill"
    @State private var capturedImage: IdentifiableImage?
    
    let isCameraTabActive: Bool
    
    var body: some View {
        GeometryReader{ geometry in
            VStack(spacing: 0){
                HStack {
                    Spacer()
                }
                .frame(height: 40)
                .padding(.top, 10)
                
                VStack{
                    CameraPreviewView(cameraEngine: cameraEngine)
                        .aspectRatio(3/4, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                }.onAppear{
                    if isCameraTabActive{
                        cameraEngine.startSession()
                    }
                }
                .onDisappear{
                    cameraEngine.stopSession()
                }
                
                Spacer()
                
                HStack(spacing: 60){
                    Button(action:{
                        flashIcon = cameraEngine.toggleFlash()
                    }){
                        Image(systemName: flashIcon)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.blueAccent)
                    }
                    
                    Button(action:{
                        cameraEngine.captureImage()
                    }){
                        Circle()
                            .stroke(Color.blueAccent, lineWidth: 4)
                            .frame(width:80, height:80)
                            .overlay(
                                Circle()
                                    .fill(Color.blueAccent)
                                    .frame(width:65, height:65)
                            )
                    }
                    
                    Button(action:{
                        cameraEngine.flipCamera()
                    }){
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.blueAccent)
                    }
                }
                Spacer()
            }
        }
        .onChange(of: isCameraTabActive){ _, isActive in
            if isActive{
                cameraEngine.startSession()
            }
            else{
                cameraEngine.stopSession()
            }
        }
        .onReceive(cameraEngine.$image) { image in
            guard let image else { return }
            capturedImage = IdentifiableImage(image: image)
        }
        .fullScreenCover(item: $capturedImage) { wrapping in
            CreateMemoryView(image: wrapping.image) {
                capturedImage = nil
                cameraEngine.image = nil
            }
        }
    }
}

private struct IdentifiableImage: Identifiable {
    let id = UUID()
    let image: UIImage
}

#Preview {
    CameraView(isCameraTabActive: true)
}
