//
//  PlayerView.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    let podcast: Podcast
    let episode: Episode
    @StateObject private var audioPlayer = AudioPlayer()
    @State private var currentEpisodeIndex: Int
    
    init(podcast: Podcast, episode: Episode) {
        self.podcast = podcast
        self.episode = episode
        self._currentEpisodeIndex = State(initialValue: podcast.episodes.firstIndex(where: { $0.id == episode.id }) ?? 0)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(podcast.title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                AsyncImage(url: URL(string: episode.imageURL ?? podcast.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Text(episode.title)
                    .font(.headline)
                
                Text(episode.description)
                    .font(.body)
                
                HStack {
                    Button(action: previousEpisode) {
                        Image(systemName: "backward.fill")
                    }
                    .disabled(currentEpisodeIndex == 0)
                    
                    Spacer()
                    
                    Button(action: {
                        audioPlayer.togglePlayPause(url: episode.audioURL)
                    }) {
                        Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    }
                    
                    Spacer()
                    
                    Button(action: nextEpisode) {
                        Image(systemName: "forward.fill")
                    }
                    .disabled(currentEpisodeIndex == podcast.episodes.count - 1)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Episode Player")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func previousEpisode() {
        guard currentEpisodeIndex > 0 else { return }
        currentEpisodeIndex -= 1
        playCurrentEpisode()
    }
    
    private func nextEpisode() {
        guard currentEpisodeIndex < podcast.episodes.count - 1 else { return }
        currentEpisodeIndex += 1
        playCurrentEpisode()
    }
    
    private func playCurrentEpisode() {
        let newEpisode = podcast.episodes[currentEpisodeIndex]
        audioPlayer.play(url: newEpisode.audioURL)
    }
}

