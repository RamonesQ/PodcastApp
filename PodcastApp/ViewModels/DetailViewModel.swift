//
//  DetailViewModel.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published var podcast: Podcast
    @Published var displayedEpisodes: [Episode] = []

    private var currentPage = 0
    private let pageSize = 20

    var hasMoreEpisodes: Bool {
        displayedEpisodes.count < podcast.episodes.count
    }

    init(podcast: Podcast) {
        self.podcast = podcast
        loadMoreEpisodes()
    }

    func loadMoreEpisodes() {
        let startIndex = currentPage * pageSize
        let endIndex = min(startIndex + pageSize, podcast.episodes.count)

        guard startIndex < podcast.episodes.count else { return }

        let newEpisodes = Array(podcast.episodes[startIndex..<endIndex])
        displayedEpisodes.append(contentsOf: newEpisodes)
        currentPage += 1
    }
}
