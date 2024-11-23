//
//  DetailView.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel
    
    init(podcast: Podcast) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(podcast: podcast))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                AsyncImage(url: URL(string: viewModel.podcast.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                Text("Author: \(viewModel.podcast.author)")
                    .font(.subheadline)
                
                Text("Language: \(viewModel.podcast.language)")
                    .font(.subheadline)
                
                if viewModel.podcast.explicit {
                    Text("Explicit Content")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                
                Text("Description:")
                    .font(.headline)
                    .padding(.top)
                
                Text(viewModel.podcast.description)
                    .font(.body)
                
                Text("Episodes:")
                    .font(.headline)
                    .padding(.top)
                
                List {
                    ForEach(viewModel.podcast.episodes) { episode in
                        Button(action: {
                            print("Episode tapped: \(episode.title)")
                        }) {
                            EpisodeRowView(episode: episode)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .frame(height: CGFloat(viewModel.podcast.episodes.count) * 100)
            }
            .padding()
        }
        .navigationTitle(viewModel.podcast.title)
    }
}

struct EpisodeRowView: View {
    let episode: Episode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(episode.title)
                .font(.subheadline)
                .lineLimit(1)
            Text("About: \(episode.description)")
                .font(.caption2)
                .lineLimit(2)
            Text("Duration: \(episode.duration)")
                .font(.caption2)
            Text("Published: \(episode.publishDate)")
                .font(.caption2)
        }
        .padding(.vertical, 5)
    }
}
