//
//  DetailView.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel = DetailViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.podcast?.title ?? "")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Author: \(viewModel.podcast?.author ?? "")")
                    .font(.subheadline)

                Text("Language: \(viewModel.podcast?.language ?? "")")
                    .font(.subheadline)

                Text("Explicit: \(viewModel.podcast?.explicit == true ? "Yes" : "No")")
                    .font(.subheadline)

                AsyncImage(url: URL(string: viewModel.podcast?.imageURL ?? "")) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(height: 200)
                } placeholder: {
                    ProgressView()
                }

                Text("Description:")
                    .font(.headline)
                    .padding(.top)

                Text(viewModel.podcast?.description ?? "")
                    .font(.body)

                Text("Episodes:")
                    .font(.headline)
                    .padding(.top)

                ForEach(viewModel.podcast?.episodes ?? []) { episode in
                    VStack(alignment: .leading) {
                        Text(episode.title)
                            .font(.headline)
                        Text("Duration: \(episode.duration)")
                            .font(.subheadline)
                        Text("Published: \(episode.publishDate)")
                            .font(.subheadline)
                    }
                    .padding(.vertical)
                }
            }
            .padding()
        }
        .navigationTitle("Podcast Details")
    }
}
