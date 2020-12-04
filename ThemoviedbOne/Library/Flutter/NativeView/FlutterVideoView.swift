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

class FlutterVideoViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FlutterVideoView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

final class FlutterVideoView: NSObject {
    private let videoView = UIView()
    
    private let channel: FlutterMethodChannel
    private var frameSubscription: NSKeyValueObservation?
    
    private lazy var captureSession: AVCaptureSession = {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        return captureSession
    }()

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        self.channel = FlutterMethodChannel(name: "flutterView",
                                            binaryMessenger: messenger,
                                            codec: FlutterStandardMethodCodec(readerWriter: FlutterStandardReaderWriter()))
        super.init()
        print(frame)
        videoView.frame = frame
        
        self.frameSubscription = videoView.observe(\.frame) {[weak self] (view, observedValue) in
            guard let self = self else {
                return
            }
            print(self.videoView.frame)
            
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
                print("input added")
            } else {
                print("cant add input")
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
}

extension FlutterVideoView: FlutterPlatformView {
    func view() -> UIView {
        return videoView
    }
}
