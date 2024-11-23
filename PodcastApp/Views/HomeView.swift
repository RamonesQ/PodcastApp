//
//  HomeView.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 20/11/24.
//

import SwiftUI

struct HomeView: View {
    @State var rssLink: String = ""
    @State private var episode: Episode?
    @State private var language: String = ""
    @State private var author: String = ""
    @State private var showingDetail = false
    
    let parser = RSSParser()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Podcast URL", text: $rssLink)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Load Podcast") {
                    loadPodcast()
                }
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .background(Color(red: 0, green: 0.53, blue: 0.84))
                .cornerRadius(15)
                
                NavigationLink(destination: DetailView(episode: episode ?? Episode(), language: language, author: author), isActive: $showingDetail) {
                    EmptyView()
                }
            }
            .padding()
            .navigationTitle("Podcast Loader")
        }
    }
    
    private func loadPodcast() {
        if let (loadedEpisode, loadedLanguage, loadedAuthor) = parser.parseRSSSample() {
            episode = loadedEpisode
            language = loadedLanguage
            author = loadedAuthor
            showingDetail = true
        }
    }
}
