//
//  RecordViewController.swift
//  KJPlayerDemo
//
//  Created by 77。 on 2022/3/19.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import KJPlayer

class RecordViewController: BaseViewController {
    
    lazy var player: KJAVPlayer = KJAVPlayer.init(withPlayerView: playerView)
    
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
    
    func setupPlayer() {
        let videoURL = "https://mp4.vjshi.com/2017-11-21/7c2b143eeb27d9f2bf98c4ab03360cfe.mp4"
        let provider = Provider.init(videoURL: videoURL)
        player.playerView = playerView
        player.delegate = self
        player.recordDelegate = self
        player.provider = provider
        
        player.kj_play()
    }
    
    func setupUI() {
        
    }
}

extension RecordViewController: KJPlayerDelegate {

}

extension RecordViewController: KJPlayerRecordDelegate {
   
    func kj_recordTime(with player: KJBasePlayer) -> Bool {
        return true
    }
    
    func kj_recordTime(with player: KJBasePlayer, lastTime: TimeInterval) {
        print("lastTime: \(lastTime)")
    }
}
