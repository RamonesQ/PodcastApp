//
//  PlayerView.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import SwiftUI

struct PlayerView: View {
    @StateObject private var viewModel: PlayerViewModel
    
    init(podcast: Podcast, episode: Episode) {
        _viewModel = StateObject(wrappedValue: PlayerViewModel(podcast: podcast, episode: episode))
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(viewModel.podcast.title)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.subheadline)
                    AsyncImage(url: URL(string: viewModel.currentEpisode.imageURL ?? viewModel.podcast.imageURL)) { status in
                        switch status {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                        default:
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text(viewModel.currentEpisode.title)
                        .font(.headline)
                    
                    Text(viewModel.currentEpisode.description)
                        .font(.body)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: viewModel.onAppear)
            .onDisappear(perform: viewModel.onDisappear)
        }
        VStack {
            VStack {
                Slider(value: $viewModel.seekValue, in: 0...viewModel.duration) { editing in
                    viewModel.isSeeking = editing
                    if !editing {
                        viewModel.seek(to: viewModel.seekValue)
                    }
                }
                HStack {
                    Text(TimeFormatter.formatTime(viewModel.currentTime))
                    Spacer()
                    Text(TimeFormatter.formatTime(viewModel.duration))
                }
                .font(.caption)
            }
            HStack {
                Button(action: viewModel.previousEpisode) {
                    Image(systemName: "backward.fill")
                }
                .disabled(viewModel.currentEpisodeIndex == 0)
                Spacer()
                Button(action: viewModel.togglePlayPause) {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
                Spacer()
                
                Button(action: viewModel.nextEpisode) {
                    Image(systemName: "forward.fill")
                }
                .disabled(viewModel.currentEpisodeIndex == viewModel.podcast.episodes.count - 1)
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
    }
}
