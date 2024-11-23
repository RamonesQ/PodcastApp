//
//  PodcastStorage.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation

protocol PodcastStorageProtocol {
    func savePodcast(_ podcast: Podcast) throws
    func loadPodcast() throws -> Podcast
}

class PodcastStorage: PodcastStorageProtocol {
    private let userDefaults = UserDefaults.standard
    private let podcastKey = "lastPodcast"
    
    func savePodcast(_ podcast: Podcast) throws {
        do {
            let encodedData = try JSONEncoder().encode(podcast)
            userDefaults.set(encodedData, forKey: podcastKey)
        } catch {
            throw PodcastAppError.encodingError
        }
    }
    
    func loadPodcast() throws -> Podcast {
        guard let data = userDefaults.data(forKey: podcastKey) else {
            throw PodcastAppError.dataNotFound
        }
        
        do {
            return try JSONDecoder().decode(Podcast.self, from: data)
        } catch {
            throw PodcastAppError.decodingError
        }
    }
}
