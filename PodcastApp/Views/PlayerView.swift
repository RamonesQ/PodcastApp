//
//  PlayerView.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import SwiftUI

struct PlayerView: View {
    let podcast: Podcast
    let episode: Episode
    
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
            }
            .padding()
        }
        .navigationTitle("Episode Player")
        .navigationBarTitleDisplayMode(.inline)
    }
}
