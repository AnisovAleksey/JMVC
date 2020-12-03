//
//  FlutterWorker.swift
//  ThemoviedbOne
//
//  Created by Aleksey Anisov on 03.12.2020.
//  Copyright © 2020 jonfir. All rights reserved.
//

import Flutter
import FlutterPluginRegistrant

protocol GameViewControllerFactory {
    func createViewController() -> UIViewController
}

final class FlutterWorker {
    private let customNavigationChannel: FlutterMethodChannel
    private let router: Router
    private let flutterEngine: FlutterEngine
    
    init(router: Router) {
        self.router = router
        self.flutterEngine = FlutterEngine(name: "flutterApp", project: nil, allowHeadlessExecution: true)
        self.flutterEngine.run()
        self.customNavigationChannel = FlutterMethodChannel(name: "flutterApp/customNavigation",
                                                            binaryMessenger: flutterEngine.binaryMessenger,
                                                            codec: FlutterStandardMethodCodec(readerWriter: FlutterStandardReaderWriter()))
        setupChannels()
    }
    
    private func setupChannels() {
        customNavigationChannel.setMethodCallHandler {[weak self] (methodCall, result) in
            guard let self = self else {
                return
            }
            switch methodCall.method {
            case "dismissCurrent":
                self.router.dismissModule()
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: flutterEngine)
    }
}

extension FlutterWorker: GameViewControllerFactory {
    func createViewController() -> UIViewController {
        return FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    }
}
