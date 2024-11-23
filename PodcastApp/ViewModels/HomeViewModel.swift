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
    private let podcastService: PodcastServiceProtocol
    private let storage: PodcastStorageProtocol
    
    init(podcastService: PodcastServiceProtocol = PodcastService(),
         storage: PodcastStorageProtocol = PodcastStorage()) {
        self.podcastService = podcastService
        self.storage = storage
    }
    
    func loadPodcast() {
        isLoading = true
        error = nil

        podcastService.fetchPodcast(from: rssLink)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] podcast in
                do {
                    try self?.storage.savePodcast(podcast)
                    self?.navigateToDetail = true
                } catch {
                    self?.error = error.localizedDescription
                }
            }
            .store(in: &cancellables)
    }
}
