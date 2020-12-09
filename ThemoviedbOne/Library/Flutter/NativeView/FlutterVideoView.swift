//
//  FlutterVideoView.swift
//  ThemoviedbOne
//
//  Created by Aleksey Anisov on 04.12.2020.
//  Copyright © 2020 jonfir. All rights reserved.
//

import UIKit
import Flutter
import AVFoundation

class FlutterMyVideoViewFactory: NSObject, FlutterPlatformViewFactory {
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    func create(withFrame frame: CGRect,
                viewIdentifier viewId: Int64,
                arguments args: Any?) -> FlutterPlatformView {
        return FlutterMyVideoView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args)
    }
}

final class FlutterMyVideoView: NSObject {
    private let videoView = UIView()
    
    private var frameSubscription: NSKeyValueObservation?
    
    private lazy var captureSession: AVCaptureSession = {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        return captureSession
    }()

    init(frame: CGRect,
         viewIdentifier viewId: Int64,
         arguments args: Any?) {
        super.init()
        videoView.frame = frame
        
        self.frameSubscription = videoView.observe(\.frame) {[weak self] (view, observedValue) in
            guard let self = self else {
                return
            }
            
            self.videoView.layer.sublayers?.forEach {
                $0.frame = self.videoView.bounds
            }
        }
    
        setupVideoLayer()
    }
    
    private func setupVideoLayer() {
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    
                videoPreviewLayer.videoGravity = .resizeAspect
                videoPreviewLayer.connection?.videoOrientation = .portrait
                videoView.layer.addSublayer(videoPreviewLayer)
                videoPreviewLayer.frame = videoView.bounds
                captureSession.startRunning()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
}

extension FlutterMyVideoView: FlutterPlatformView {
    func view() -> UIView {
        return videoView
    }
}
