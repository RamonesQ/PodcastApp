//
//  PodcastAppError.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation

enum PodcastAppError: Error {
    case networkError(underlying: Error)
    case invalidURL
    case parsingError
    case decodingError
    case encodingError
    case dataNotFound
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidURL:
            return "Invalid URL provided"
        case .parsingError:
            return "Failed to parse the RSS feed"
        case .decodingError:
            return "Failed to decode the data"
        case .encodingError:
            return "Failed to encode the data"
        case .dataNotFound:
            return "Required data not found"
        case .unknownError:
            return "An unknown error occurred"
        }
    }
}
