//
//  PodcastService.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation
import Combine

protocol PodcastServiceProtocol {
    func fetchPodcast(from urlString: String) -> AnyPublisher<Podcast, PodcastAppError>
}

class PodcastService: PodcastServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let parser: RSSParserProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         parser: RSSParserProtocol = RSSParser()) {
        self.networkService = networkService
        self.parser = parser
    }
    
    func fetchPodcast(from urlString: String) -> AnyPublisher<Podcast, PodcastAppError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: PodcastAppError.invalidURL).eraseToAnyPublisher()
        }
        
        return networkService.fetchData(from: url)
            .tryMap { data -> Podcast in
                guard let podcast = self.parser.parse(data: data) else {
                    throw PodcastAppError.parsingError
                }
                return podcast
            }
            .mapError { error -> PodcastAppError in
                if let podcastError = error as? PodcastAppError {
                    return podcastError
                }
                return .unknownError
            }
            .eraseToAnyPublisher()
    }
}
