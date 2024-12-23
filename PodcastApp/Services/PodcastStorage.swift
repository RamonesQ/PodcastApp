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
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let metadataFile: URL

    init() {
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesDirectory.appendingPathComponent("PodcastCache")
        metadataFile = cacheDirectory.appendingPathComponent("metadata.plist")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }

    private func getUniqueFilename(for url: String) -> String {
        let urlData = Data(url.utf8)
        return urlData.base64EncodedString().replacingOccurrences(of: "/", with: "_")
    }

    private func saveMetadata(_ metadata: [String: String]) {
        (metadata as NSDictionary).write(to: metadataFile, atomically: true)
    }

    private func loadMetadata() -> [String: String] {
        (NSDictionary(contentsOf: metadataFile) as? [String: String]) ?? [:]
    }

    func savePodcast(_ podcast: Podcast, forURL url: String) throws {
        let encodedData = try JSONEncoder().encode(podcast)
        let filename = getUniqueFilename(for: url)
        let fileURL = cacheDirectory.appendingPathComponent(filename)
        try encodedData.write(to: fileURL)

        var metadata = loadMetadata()
        metadata[url] = filename
        saveMetadata(metadata)
    }

    func loadPodcast(forURL url: String) throws -> Podcast {
        let metadata = loadMetadata()
        guard let filename = metadata[url] else {
            throw PodcastAppError.dataNotFound
        }
        let fileURL = cacheDirectory.appendingPathComponent(filename)
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(Podcast.self, from: data)
    }

    func getAllCachedPodcasts() -> [String: Podcast] {
        var result: [String: Podcast] = [:]
        let metadata = loadMetadata()

        for (url, filename) in metadata {
            let fileURL = cacheDirectory.appendingPathComponent(filename)
            do {
                let data = try Data(contentsOf: fileURL)
                let podcast = try JSONDecoder().decode(Podcast.self, from: data)
                result[url] = podcast
            } catch {
                print("Error loading podcast from file: \(error)")
            }
        }

        return result
    }

    func clearCache() {
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
}
