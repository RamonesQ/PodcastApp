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
                Text(viewModel.episode?.title ?? "")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Author: \(viewModel.author)")
                    .font(.subheadline)

                Text("Published: \(viewModel.episode?.publishDate ?? "")")
                    .font(.subheadline)

                Text("Duration: \(viewModel.episode?.duration ?? "")")
                    .font(.subheadline)

                Text("Language: \(viewModel.language)")
                    .font(.subheadline)

                Text("Description:")
                    .font(.headline)
                    .padding(.top)

                Text(viewModel.episode?.description ?? "")
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle("Podcast Details")
    }
}
