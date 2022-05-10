//
//  TesseractViewModel.swift
//  OCRTest
//
//  Created by Harry on 2022/05/09.
//

import AVFoundation
import TesseractOCR
import SwiftUI

class TesseractViewModel: ObservableObject {
    var isConfigure = false
    let output = AVCaptureVideoDataOutput()
    var tesseract = G8Tesseract()
    
    @Published var session: AVCaptureSession = AVCaptureSession()
    @Published var result: String = ""
    
    func requestAndCheckPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // 권한 요청
            AVCaptureDevice.requestAccess(for: .video) { authStatus in
                if authStatus {
                    DispatchQueue.main.async {
                        self.setupCamera()
                    }
                }
            }
        case .restricted:
            break
        case .authorized:
            // 이미 권한 받은 경우 셋업
            setupCamera()
        default:
            // 거절했을 경우
            print("Permession declined")
        }
    }
    
    func setupCamera() {
        if isConfigure == false {
            initInput()
            initOutput()
            isConfigure = true
        }
    }
    
    func initInput() {
        // Video 방식으로 촬영하겠다.
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
            print("error")
        }
    }
    
    func initOutput() {
        session.addOutput(output)
    }
    
    func initTesseract() {
        if let newTesseract = G8Tesseract(language: "kor") {
            tesseract = newTesseract
        }
    }
    
    func scanImage(_ sampleBuffer: CMSampleBuffer) {
        guard let bufferImage = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvImageBuffer: bufferImage)
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)!
        let image = UIImage(cgImage: cgImage)
        tesseract.image = image
        tesseract.recognize()
        if let recognizedText = tesseract.recognizedText {
            session.stopRunning()
            result = recognizedText
        }
    }
}
