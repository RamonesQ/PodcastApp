//
//  DetailViewModel.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published var podcast: Podcast
    
    init(podcast: Podcast) {
        self.podcast = podcast
    }
}

