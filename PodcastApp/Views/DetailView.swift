//
//  DetailView.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import SwiftUI

struct DetailView: View {
    let episode: Episode
    let language: String
    let author: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(episode.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Author: \(author)")
                    .font(.subheadline)
                
                Text("Published: \(episode.publishDate)")
                    .font(.subheadline)
                
                Text("Duration: \(episode.duration)")
                    .font(.subheadline)
                
                Text("Language: \(language)")
                    .font(.subheadline)
                
                Text("Description:")
                    .font(.headline)
                    .padding(.top)
                
                Text(episode.description)
                    .font(.body)
            }
            .padding()
        }
    }
}

