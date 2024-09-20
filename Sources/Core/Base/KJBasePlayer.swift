//
//  KJBasePlayer.swift
//  KJPlayer
//
//  Created by abas on 2021/12/14.
//

import Foundation
import UIKit

@objc(KJBasePlayer)
open class KJBasePlayer: NSObject {
    
    @objc public weak var delegate: KJPlayerDelegate?
    /// Player control
    @objc public weak var playerView: KJPlayerView?
    /// Configuration information.
    @objc public var provider: Provider? = nil
    
    /// Play speed, 0 ~ 2.
    @objc public var speed: Float = 1.0
    /// is mute
    @objc public var muted: Bool = false
    /// play volume
    @objc public var volume: Float = 1.0
    /// Whether to open auto play
    @objc public var autoPlay: Bool = true
    
    // MARK: - private
    private var _originalURL: NSURL? = nil
    private var _playURL: NSURL? = nil
    private var userPause: Bool = false
    private var localed: Bool = false
    private var replay: Bool = false
    private var playing: Bool = false
    
    @objc public convenience init(withPlayerView view: KJPlayerView) {
        self.init()
        self.playerView = view
    }
    
    @objc public required override init() {
        super.init()
        self.setupTimer(1)
        self.setupNotification()
    }
    
    deinit {
        #if DEBUG
        print("🎷\(String(describing: self)): Deinited")
        #endif
        NotificationCenter.default.removeObserver(self)
        self.deinitTimer()
        BridgeMethod.deinit(self).dealloc()
    }
    
    internal func getVideoFrame() -> CGRect {
        guard let playerView = playerView else {
            return .zero
        }
        return playerView.bounds
    }
    
    /// Mainly deal with state and UI related here,
    /// `Sub class deal with the main logical ideas
    var playerStatus: PlayerStatus? {
        didSet {
            guard let playerStatus = playerStatus else {
                return
            }
            switch playerStatus {
            case .prepare(let provider):
                self.playFailedObserve = nil
                self.userPause = false
                self.replay = false
                self.playing = false
                self.playFinishedTimeObserve = 0.0
                self.setupVideoURL(provider.videoURL)
                break
            case .beginPlay:
                self.userPause = false
                self.playing = true
                break
            case .playing(let time):
                self.playing = true
                if userPause == false, !BridgeMethod.freeLookEnded(self) {
                    self.playStateObserve = .playing
                }
                self.currentTimeObserve = time
                break
            case .paused(let user):
                self.playing = false
                if user == true {
                    self.playStateObserve = .paused
                }
                self.userPause = user
                break
            case .playFinished(let skip):
                self.playing = false
                if skip {
                    self.playFinishedTimeObserve = self.currentTime
                } else {
                    self.playFinishedTimeObserve = self.totalTime
                }
                BridgeMethod.end(self).playFinished()
                break
            case .failed(let error):
                self.playing = false
                self.playFailedObserve = error
                break
            }
        }
    }
    
    /// Configuration play ink
    @discardableResult
    private func setupVideoURL(_ urlString: String?) -> NSURL? {
        var videoURL: NSURL? = nil
        if let videoURLString = urlString {
            if Common.Function.isOnlineResource(videoURLString) {
                self.localed = false
                videoURL = NSURL.init(string: videoURLString)
            } else {
                self.localed = true
                videoURL = NSURL.init(fileURLWithPath: videoURLString)
            }
        }
        self._originalURL = videoURL
        self._playURL = videoURL
        return videoURL
    }
    
    // MARK: - Observe
    internal var playStateObserve: KJPlayerState? {
        willSet {
            guard let newState = newValue else { return }
            var state: KJPlayerState?
            if playStateObserve == nil {
                state = newState
            } else if newState != playStateObserve {
                state = newState
            } else {
                return
            }
            DispatchQueue.main.async {
                self.delegate?.kj_player(_:state:)?(self, state!)
            }
        }
    }
    
    internal var currentTimeObserve: TimeInterval? = 0.0 {
        willSet {
            guard let newTime = newValue, let oldTime = currentTimeObserve else { return }
            if newTime != oldTime {
                DispatchQueue.main.async {
                    self.delegate?.kj_player(_:current:)?(self, newTime)
                }
            }
        }
    }
    
    internal var loadedTimeObserve: TimeInterval? = 0.0 {
        willSet {
            guard let newTime = newValue, let oldTime = loadedTimeObserve else { return }
            if newTime != oldTime, newTime > 0 {
                DispatchQueue.main.async {
                    self.delegate?.kj_player(_:loadedTime:)?(self, newTime)
                }
            }
        }
    }
    
    internal var totalTimeObserve: TimeInterval? = 0.0 {
        willSet {
            guard let newTime = newValue, let oldTime = totalTimeObserve else { return }
            if newTime != oldTime, newTime > 0 {
                DispatchQueue.main.async {
                    self.delegate?.kj_player(_:total:)?(self, newTime)
                }
            }
        }
    }
    
    internal var videoSizeObserve: CGSize? = .zero {
        willSet {
            guard let newVideoSize = newValue, let oldVideoSize = videoSizeObserve else { return }
            if newVideoSize != oldVideoSize {
                DispatchQueue.main.async {
                    self.delegate?.kj_player(_:videoSize:)?(self, newVideoSize)
                }
            }
        }
    }
    
    internal var playFailedObserve: NSError? = nil {
        willSet {
            guard let newError = newValue, let oldError = playFailedObserve else { return }
            if newError != oldError {
                self.delegate?.kj_player(_:playFailed:)?(self, newError)
            }
        }
    }
    
    /// End of play observer
    private var playFinishedTimeObserve: TimeInterval? {
        willSet {
            guard let newTime = newValue else { return }
            if (playFinishedTimeObserve == nil || newTime != playFinishedTimeObserve) && newTime > 0 {
                DispatchQueue.main.async {
                    self.delegate?.kj_player(_:playFinished:)?(self, newTime)
                }
            }
        }
    }
}

extension KJBasePlayer: KJPlayer {
    @objc public var currentTime: TimeInterval { return self.currentTimeObserve! }
    @objc public var totalTime: TimeInterval { return self.totalTimeObserve! }
    @objc public var videoSize: CGSize { return self.videoSizeObserve! }
    @objc public var originalURL: NSURL? { return self._originalURL }
    @objc public var playURL: NSURL? { return self._playURL }
    @objc public var isPlaying: Bool { return self.playing }
    @objc public var isUserPause: Bool { return self.userPause }
    @objc public var isOnlineSource: Bool { return self.localed }
    @objc public var isReplay: Bool { return self.replay }
    @objc public var loadedProgress: Float {
        if self.isOnlineSource == false {
            return 1.0
        }
        if self.totalTime <= 0 {
            return 0
        }
        return Float(min(self.loadedTimeObserve! / self.totalTime, 1))
    }
    
    @objc public var isLiveStreaming: Bool {
        if let videoURL = self._originalURL {
            return Common.Function.videoAesset(videoURL) == .HLS
        } else {
            return false
        }
    }
    
    @objc public func kj_play() {
        self.userPause = false
        self.playerStatus = .beginPlay
    }
    
    @objc public func kj_replay() {
        self.replay = true
        self.userPause = false
        let time = BridgeMethod.skipTime(self)
        self.kj_appointTime(time)
    }
    
    @objc public func kj_pause() {
        self.userPause = true
        self.playerStatus = .paused(user: true)
    }
    
    @objc public func kj_stop() {
        self.userPause = false
        DispatchQueue.main.async {
            self.delegate?.kj_player(_:stopped:)?(self, self.currentTime)
        }
    }
    
    @objc public func kj_appointTime(_ time: TimeInterval) {
        self.currentTimeObserve = time
    }
}
