//
//  AVPlayerViewController.swift
//  KJPlayerDemo_Example
//
//  Created by 77。 on 2021/12/23.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import KJPlayer

class AVPlayerViewController: BaseViewController {
    
    lazy var player: KJAVPlayer = KJAVPlayer.shared
    //lazy var player: KJAVPlayer = KJAVPlayer.init(withPlayerView: playerView)
    
    lazy var button: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = UIColor.yellow
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        button.setTitle("点我截图", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func buttonAction(_ sender: UIButton) {
        let image = Screenshots.screenshots(player, time: player.currentTime)
        button.setImage(image, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupPlayer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        KJAVPlayer.deinitShared()
    }
    
    func setupUI() {
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 0.5),
        ])
    }
    
    func setupPlayer() {
        let videoURL = "https://mp4.vjshi.com/2017-11-21/7c2b143eeb27d9f2bf98c4ab03360cfe.mp4"
        let provider = Provider.init(videoURL: videoURL)
        player.playerView = playerView
        player.delegate = self
        player.provider = provider
        
        player.kj_play()
    }
}

extension AVPlayerViewController: KJPlayerDelegate {
    
    func kj_player(_ player: KJBasePlayer, state: KJPlayerState) {
        print("----state:\(state.mapString)")
    }
    
    func kj_player(_ player: KJBasePlayer, current: TimeInterval) {
        //print("----current:\(current)")
    }
    
    func kj_player(_ player: KJBasePlayer, playFailed: NSError) {
        print("----playFailed:\(playFailed)")
    }
    
    func kj_player(_ player: KJBasePlayer, loadedTime: TimeInterval) {
        print("----loadedTime:\(loadedTime)")
    }
    
    func kj_player(_ player: KJBasePlayer, total: TimeInterval) {
        print("----total:\(total)")
    }
    
    func kj_player(_ player: KJBasePlayer, videoSize: CGSize) {
        print("----videoSize:\(videoSize)")
    }
    
    func kj_player(_ player: KJBasePlayer, playFinished: TimeInterval) {
        print("----playFinished:\(playFinished)")
        player.kj_replay()
    }
}
