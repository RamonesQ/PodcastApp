//
//  Podcast.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation

struct Podcast: Identifiable {
    let id: UUID
    var title: String
    var description: String
    var author: String
    var language: String
    var imageURL: String
    var explicit: Bool
    var episodes: [Episode]
    
    init(id: UUID = UUID(), title: String = "", description: String = "", author: String = "", language: String = "", imageURL: String = "", explicit: Bool = false, episodes: [Episode] = []) {
        self.id = id
        self.title = title
        self.description = description
        self.author = author
        self.language = language
        self.imageURL = imageURL
        self.explicit = explicit
        self.episodes = episodes
    }
}
