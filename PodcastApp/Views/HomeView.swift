//
//  HomeView.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 20/11/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Podcast URL", text: $viewModel.rssLink)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Load Podcast") {
                    viewModel.loadPodcast()
                }
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .background(Color(red: 0, green: 0.53, blue: 0.84))
                .cornerRadius(15)

                if viewModel.isLoading {
                    ProgressView()
                }

                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                }

                NavigationLink(
                    destination: DetailView(),
                    isActive: $viewModel.navigateToDetail
                ) {
                    EmptyView()
                }
            }
            .padding()
            .navigationTitle("Podcast Loader")
        }
    }
}
