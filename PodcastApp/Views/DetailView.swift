//
//  DetailView.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel
    @State private var isDescriptionExpanded: Bool = false

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
                    .frame(height: isDescriptionExpanded ? nil : 100)
                    .onTapGesture {
                        withAnimation {
                            isDescriptionExpanded.toggle()
                        }
                    }

                Text("Episodes:")
                    .font(.headline)
                    .padding(.top)
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.displayedEpisodes) { episode in
                        NavigationLink(destination: PlayerView(podcast: viewModel.podcast, episode: episode)) {
                            EpisodeRowView(episode: episode)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Divider()
                    }
                    if viewModel.hasMoreEpisodes {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .onAppear {
                                viewModel.loadMoreEpisodes()
                            }
                    }
                }
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
