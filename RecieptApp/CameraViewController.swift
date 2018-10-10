//
//  TesseractViewController.swift
//  RecieptApp
//
//  Created by Brice Redmond on 9/21/18.
//  Copyright © 2018 Brice Redmond. All rights reserved.
//

import UIKit
import AVFoundation

//protocol CameraControllerDelegate: class {
//    func cameraController(_ controller: CameraController, didCapture buffer: CMSampleBuffer,
//                          size: CGSize, start: CGPoint, ended: Bool, layer: CALayer)
//}
//
//final class CameraController: UIViewController {
//    private(set) lazy var cameraLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
//    
//    private lazy var captureSession: AVCaptureSession = {
//        let session = AVCaptureSession()
//        session.sessionPreset = AVCaptureSession.Preset.photo
//        
//        guard
//            let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
//            let input = try? AVCaptureDeviceInput(device: backCamera)
//            else {
//                return session
//        }
//        
//        session.addInput(input)
//        return session
//    }()
//    
//    weak var delegate: CameraControllerDelegate?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        cameraLayer.videoGravity = .resizeAspectFill
//        view.layer.addSublayer(cameraLayer)
//        
//        let gestRec = UIPanGestureRecognizer(target: self, action:#selector(panGesture(_:)))
//        view.addGestureRecognizer(gestRec)
//        
//        // register to receive buffers from the camera
//        let videoOutput = AVCaptureVideoDataOutput()
//        videoOutput.setSampleBufferDelegate(self as? AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue(label: "MyQueue"))
//        self.captureSession.addOutput(videoOutput)
//        
//        // begin the session
//        self.captureSession.startRunning()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        // make sure the layer is the correct size
//        self.cameraLayer.frame = view.bounds
//    }
//    
//    func captureOutput(
//        _ output: AVCaptureOutput,
//        didOutput sampleBuffer: CMSampleBuffer,
//        from connection: AVCaptureConnection) {
//        
//        sample = sampleBuffer
//    }
//}
