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
                .disabled(viewModel.isLoading)
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
                
                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                if !viewModel.cachedPodcasts.isEmpty {
                    Text("Previous searches")
                        .font(.headline)
                        .padding(.top)
                    
                    List {
                        ForEach(Array(viewModel.cachedPodcasts.keys), id: \.self) { url in
                            if let podcast = viewModel.cachedPodcasts[url] {
                                Button(action: {
                                    viewModel.rssLink = url
                                    viewModel.loadPodcast()
                                }) {
                                    VStack(alignment: .leading) {
                                        Text(podcast.title)
                                            .font(.subheadline)
                                            .lineLimit(1)
                                        Text(url)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: 300)
                    
                    Button("Clear Cache") {
                        viewModel.clearCache()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 0.85, green: 0, blue: 0))
                    .cornerRadius(15)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("The Podcast App")
            .background(
                NavigationLink(
                    destination: Group {
                        if let podcast = viewModel.selectedPodcast {
                            DetailView(podcast: podcast)
                        }
                    },
                    isActive: $viewModel.navigateToDetail
                ) {
                    EmptyView()
                }
            )
        }
    }
}
