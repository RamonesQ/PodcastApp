//
//  AudioPlayer.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation
import AVFoundation

class AudioPlayer: ObservableObject {
    @Published var isPlaying = false
    private var audioPlayer: AVPlayer?
    
    func play(url: String) {
        guard let url = URL(string: url) else { return }
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer?.play()
        isPlaying = true
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func togglePlayPause(url: String) {
        if isPlaying {
            pause()
        } else {
            play(url: url)
        }
    }
}

