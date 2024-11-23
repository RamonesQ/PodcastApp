//
//  PodcastStorage.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation

protocol PodcastStorageProtocol {
    func savePodcast(_ podcast: Podcast, forURL url: String) throws
    func loadPodcast(forURL url: String) throws -> Podcast
    func getAllCachedPodcasts() -> [String: Podcast]
    func clearCache()
}

class PodcastStorage: PodcastStorageProtocol {
    private let userDefaults = UserDefaults.standard
    private let cachedPodcastsKey = "cachedPodcasts"
    
    private var cachedPodcasts: [String: Data] {
        get { userDefaults.dictionary(forKey: cachedPodcastsKey) as? [String: Data] ?? [:] }
        set { userDefaults.set(newValue, forKey: cachedPodcastsKey) }
    }
    
    func savePodcast(_ podcast: Podcast, forURL url: String) throws {
        do {
            let encodedData = try JSONEncoder().encode(podcast)
            var updatedCache = cachedPodcasts
            updatedCache[url] = encodedData
            cachedPodcasts = updatedCache
        } catch {
            throw PodcastAppError.encodingError
        }
    }
    
    func loadPodcast(forURL url: String) throws -> Podcast {
        guard let data = cachedPodcasts[url] else {
            throw PodcastAppError.dataNotFound
        }
        
        do {
            return try JSONDecoder().decode(Podcast.self, from: data)
        } catch {
            throw PodcastAppError.decodingError
        }
    }
    
    func getAllCachedPodcasts() -> [String: Podcast] {
        var result: [String: Podcast] = [:]
        for (url, data) in cachedPodcasts {
            if let podcast = try? JSONDecoder().decode(Podcast.self, from: data) {
                result[url] = podcast
            }
        }
        return result
    }
    
    func clearCache() {
        cachedPodcasts = [:]
    }
}
