//
//  NetworkService.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func fetchData(from url: URL) -> AnyPublisher<Data, PodcastAppError>
}

class NetworkService: NetworkServiceProtocol {
    func fetchData(from url: URL) -> AnyPublisher<Data, PodcastAppError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { PodcastAppError.networkError(underlying: $0) }
            .eraseToAnyPublisher()
    }
}
