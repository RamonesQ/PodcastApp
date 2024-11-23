//
//  Episode.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation

struct Episode: Codable, Identifiable {
    let id: UUID
    var title: String
    var description: String
    var publishDate: String
    var duration: String
    var guid: String
    var audioURL: String
    var imageURL: String
    var season: Int
    var episodeNumber: Int
    var episodeType: String
    
    init(id: UUID = UUID(), title: String = "", description: String = "", publishDate: String = "", duration: String = "", guid: String = "", audioURL: String = "", imageURL: String = "", season: Int = 0, episodeNumber: Int = 0, episodeType: String = "") {
        self.id = id
        self.title = title
        self.description = description
        self.publishDate = publishDate
        self.duration = duration
        self.guid = guid
        self.audioURL = audioURL
        self.imageURL = imageURL
        self.season = season
        self.episodeNumber = episodeNumber
        self.episodeType = episodeType
    }
}
