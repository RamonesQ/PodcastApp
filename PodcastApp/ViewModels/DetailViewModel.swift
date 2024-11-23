//
//  DetailViewModel.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published var episode: Episode?
    @Published var language: String = ""
    @Published var author: String = ""
    
    init() {
        loadLastPodcast()
    }
    
    private func loadLastPodcast() {
        if let episodeData = UserDefaults.standard.data(forKey: "lastEpisode"),
           let episode = try? JSONDecoder().decode(Episode.self, from: episodeData) {
            self.episode = episode
        }
        language = UserDefaults.standard.string(forKey: "lastLanguage") ?? ""
        author = UserDefaults.standard.string(forKey: "lastAuthor") ?? ""
    }
}

