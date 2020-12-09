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
    private var customNavigationChannel: FlutterMethodChannel?
    private let router: Router
    private let flutterEngine: FlutterEngine
    
    init(router: Router) {
        self.router = router
        self.flutterEngine = FlutterEngine(name: "flutterApp", project: nil, allowHeadlessExecution: true)
        
    }
    
    private func setupChannels() {
        customNavigationChannel?.setMethodCallHandler {[weak self] (methodCall, result) in
            guard let self = self else {
                return
            }
            switch methodCall.method {
            case "dismissCurrent":
                // https://github.com/flutter/engine/blob/master/shell/platform/darwin/ios/framework/Source/FlutterPlatformPlugin.mm#L218
                self.router.dismissModule()
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func startEngine() {
        self.flutterEngine.run()
        customNavigationChannel = FlutterMethodChannel(name: "flutterApp/customNavigation",
                                                       binaryMessenger: flutterEngine.binaryMessenger,
                                                       codec: FlutterStandardMethodCodec(readerWriter: FlutterStandardReaderWriter()))
        setupChannels()
        
        GeneratedPluginRegistrant.register(with: flutterEngine)
        
        flutterEngine
            .registrar(forPlugin: "platformVideoView")?
            .register(FlutterMyVideoViewFactory(), withId: "FlutterMyVideoView")
    }
}

extension FlutterWorker: GameViewControllerFactory {
    func createViewController() -> UIViewController {
        flutterEngine.destroyContext()
        startEngine()
        return FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    }
}
