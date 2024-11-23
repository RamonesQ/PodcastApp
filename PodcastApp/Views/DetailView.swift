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
                Text(viewModel.podcast.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Author: \(viewModel.podcast.author)")
                    .font(.subheadline)
                
                Text("Language: \(viewModel.podcast.language)")
                    .font(.subheadline)
                
                if viewModel.podcast.explicit {
                    Text("Explicit Content")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                
                AsyncImage(url: URL(string: viewModel.podcast.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                } placeholder: {
                    ProgressView()
                }
                .padding(.vertical)
                
                Text("Description:")
                    .font(.headline)
                    .padding(.top)
                
                Text(viewModel.podcast.description)
                    .font(.body)
                
                Text("Episodes:")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(viewModel.podcast.episodes) { episode in
                    EpisodeRowView(episode: episode)
                }
            }
            .padding()
        }
        .navigationTitle("Podcast Details")
    }
}

struct EpisodeRowView: View {
    let episode: Episode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(episode.title)
                .font(.headline)
            Text("Duration: \(episode.duration)")
                .font(.subheadline)
            Text("Published: \(episode.publishDate)")
                .font(.subheadline)
        }
        .padding(.vertical, 5)
    }
}
