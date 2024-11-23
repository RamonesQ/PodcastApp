//
//  DetailViewModel.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published var podcast: Podcast?
    @Published var error: String?
    
    private let storage: PodcastStorageProtocol
    
    init(storage: PodcastStorageProtocol = PodcastStorage()) {
        self.storage = storage
        loadLastPodcast()
    }
    
    private func loadLastPodcast() {
        do {
            podcast = try storage.loadPodcast()
        } catch {
            if let podcastError = error as? PodcastAppError {
                self.error = podcastError.localizedDescription
            } else {
                self.error = PodcastAppError.unknownError.localizedDescription
            }
        }
    }
}
