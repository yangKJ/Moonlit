//
//  Screenshots.swift
//  KJPlayer
//
//  Created by abas on 2021/12/18.
//

import Foundation
import AVFoundation

@objc public final class Screenshots: NSObject {
    
    @objc public static func screenshots(player: KJBasePlayer, time: TimeInterval) -> UIImage {
        return screenshots(player, time: time) ?? UIImage()
    }
}

extension Screenshots {
    
    public static func screenshots(_ player: KJBasePlayer, time: TimeInterval) -> UIImage? {
        if let player = player as? KJAVPlayer, let asset = player.playerItem?.asset {
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            generator.requestedTimeToleranceAfter  = CMTime.zero
            generator.requestedTimeToleranceBefore = CMTime.zero
            let _time = CMTimeMakeWithSeconds(time, preferredTimescale: Int32(NSEC_PER_SEC))
            var actualTime = CMTimeMake(value: 0, timescale: 0)
            guard let imageRef = try? generator.copyCGImage(at: _time, actualTime: &actualTime) else {
                return nil
            }
            return UIImage(cgImage: imageRef)
        }
        return nil
    }
}
