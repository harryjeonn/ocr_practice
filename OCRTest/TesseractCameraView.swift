//
//  TesseractCameraView.swift
//  OCRTest
//
//  Created by Harry on 2022/05/09.
//

import SwiftUI
import AVFoundation
import TesseractOCR

struct TesseractCameraView: UIViewRepresentable {
    let viewModel: TesseractViewModel
    
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        
        view.backgroundColor = .black
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.session = viewModel.session
        view.videoPreviewLayer.connection?.videoOrientation = .portrait
        viewModel.requestAndCheckPermissions()
        
        viewModel.initTesseract()
        viewModel.tesseract.delegate = context.coordinator
        
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        viewModel.output.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue.main)
    }
    
    // Coordinator
    func makeCoordinator() -> Coordinator {
        return Coordinator(viewModel: viewModel)
    }
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, G8TesseractDelegate {
        let viewModel: TesseractViewModel
        
        init(viewModel: TesseractViewModel) {
            self.viewModel = viewModel
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            viewModel.scanImage(sampleBuffer)
        }
        
        func progressImageRecognition(for tesseract: G8Tesseract) {
            print("recognition progress \(tesseract.progress)%")
        }
    }
}
