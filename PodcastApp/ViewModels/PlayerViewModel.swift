//
//  PlayerViewModel.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation
import Combine

class PlayerViewModel: ObservableObject {
    @Published var podcast: Podcast
    @Published var currentEpisode: Episode
    @Published var currentEpisodeIndex: Int
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var seekValue: Double = 0
    @Published var isSeeking = false
    
    private var audioPlayer: AudioPlayer
    private var cancellables = Set<AnyCancellable>()
    
    init(podcast: Podcast, episode: Episode) {
        self.podcast = podcast
        self.currentEpisode = episode
        self.currentEpisodeIndex = podcast.episodes.firstIndex(where: { $0.id == episode.id }) ?? 0
        self.audioPlayer = AudioPlayer()
        
        setupBindings()
    }
    
    private func setupBindings() {
        audioPlayer.$isPlaying
            .assign(to: \.isPlaying, on: self)
            .store(in: &cancellables)
        
        audioPlayer.$currentTime
            .sink { [weak self] time in
                guard let self = self, !self.isSeeking else { return }
                self.currentTime = time
                self.seekValue = time
            }
            .store(in: &cancellables)
        
        audioPlayer.$duration
            .assign(to: \.duration, on: self)
            .store(in: &cancellables)
    }
    
    func togglePlayPause() {
        audioPlayer.togglePlayPause(url: currentEpisode.audioURL)
    }
    
    func seek(to value: Double) {
        audioPlayer.seek(to: value)
    }
    
    func previousEpisode() {
        guard currentEpisodeIndex > 0 else { return }
        currentEpisodeIndex -= 1
        updateCurrentEpisode()
    }
    
    func nextEpisode() {
        guard currentEpisodeIndex < podcast.episodes.count - 1 else { return }
        currentEpisodeIndex += 1
        updateCurrentEpisode()
    }
    
    private func updateCurrentEpisode() {
        currentEpisode = podcast.episodes[currentEpisodeIndex]
        audioPlayer.play(url: currentEpisode.audioURL)
    }
    
    func onAppear() {
        audioPlayer.play(url: currentEpisode.audioURL)
    }
    
    func onDisappear() {
        audioPlayer.pause()
    }
}

