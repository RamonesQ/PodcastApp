//
//  HomeViewModel.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var rssLink: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var navigateToDetail: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let parser = RSSParser()
    
    func loadPodcast() {
        guard let url = URL(string: rssLink) else {
            error = "Invalid URL"
            return
        }

        isLoading = true
        error = nil

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] data in
                if let (episode, language, author) = self?.parser.parse(data: data) {
                    UserDefaults.standard.set(try? JSONEncoder().encode(episode), forKey: "lastEpisode")
                    UserDefaults.standard.set(language, forKey: "lastLanguage")
                    UserDefaults.standard.set(author, forKey: "lastAuthor")
                    self?.navigateToDetail = true
                } else {
                    self?.error = "Failed to parse podcast data"
                }
            }
            .store(in: &cancellables)
    }
}

