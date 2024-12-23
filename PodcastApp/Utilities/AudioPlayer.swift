//
//  AudioPlayer.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation
import AVFoundation
import Combine

class AudioPlayer: ObservableObject {
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0

    private var audioPlayer: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    private var currentURL: URL?

    func play(url: String) {
        guard let newURL = URL(string: url) else { return }

        if currentURL != newURL {
            setupNewPlayer(with: newURL)
        } else if !isPlaying {
            audioPlayer?.play()
            isPlaying = true
        }
    }

    private func setupNewPlayer(with url: URL) {
        currentURL = url
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)

        playerItem.publisher(for: \.status)
            .sink { [weak self] status in
                if status == .readyToPlay {
                    self?.duration = playerItem.duration.seconds
                }
            }
            .store(in: &cancellables)

        if let existingObserver = timeObserver {
            audioPlayer?.removeTimeObserver(existingObserver)
        }

        timeObserver = audioPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            self?.currentTime = time.seconds
        }

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

    func seek(to time: Double) {
        audioPlayer?.seek(to: CMTime(seconds: time, preferredTimescale: 1))
    }

    deinit {
        if let timeObserver = timeObserver {
            audioPlayer?.removeTimeObserver(timeObserver)
        }
    }
}
