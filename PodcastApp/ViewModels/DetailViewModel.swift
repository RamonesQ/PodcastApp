//
//  DetailViewModel.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published var podcast: Podcast?
    
    init() {
        loadLastPodcast()
    }
    
    private func loadLastPodcast() {
        if let podcastData = UserDefaults.standard.data(forKey: "lastPodcast"),
           let podcast = try? JSONDecoder().decode(Podcast.self, from: podcastData) {
            self.podcast = podcast
        }
    }
}


