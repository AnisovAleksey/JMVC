//
//  FlutterYoutubeVideoView.swift
//  ThemoviedbOne
//
//  Created by Aleksey Anisov on 06.12.2020.
//  Copyright © 2020 jonfir. All rights reserved.
//

import UIKit
import Flutter
import AVFoundation
import XCDYouTubeKit

final class FlutterYoutubeVideoViewFactory: NSObject, FlutterPlatformViewFactory {
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    func create(withFrame frame: CGRect,
                viewIdentifier viewId: Int64,
                arguments args: Any?) -> FlutterPlatformView {
        return FlutterYoutubeVideoView(frame: frame,
                                       viewIdentifier: viewId,
                                       arguments: args)
    }
}

final class FlutterYoutubeVideoView: NSObject {
    private let videoView = UIView()
    
    private var frameSubscription: NSKeyValueObservation?
    private var player: AVPlayer?

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
        
        guard let map = args as? [String: Any],
              let videoId = map["videoId"] as? String else {
            return
        }
    
        setupYoutubeVideo(with: videoId)
    }
    
    private func setupYoutubeVideo(with videoId: String) {
        let youtubeClient = XCDYouTubeClient.default()
        youtubeClient.getVideoWithIdentifier(videoId) { video, _ in
            guard let ytVideo = video else { fatalError("Couldn't get the video from video id") }
            
            guard let streamURL = (ytVideo.streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ??
                                    ytVideo.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue] ?? ytVideo.streamURLs[XCDYouTubeVideoQuality.medium360.rawValue] ?? ytVideo.streamURLs[XCDYouTubeVideoQuality.small240.rawValue]) else { fatalError("Couldn't get URL for this quality") }
            self.player = AVPlayer(url: streamURL)
            let playerLayer = AVPlayerLayer(player: self.player)
            playerLayer.frame = self.videoView.bounds
            self.videoView.layer.addSublayer(playerLayer)
            
            self.player?.play()
            self.player?.isMuted = true
        }
    }
}

extension FlutterYoutubeVideoView: FlutterPlatformView {
    func view() -> UIView {
        return videoView
    }
}
