//
//  HomeView.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 20/11/24.
//

import SwiftUI

struct HomeView: View {
    @State var rssLink: String = ""
    let parser = RSSParser()
    
    
    var body: some View {
        VStack {
            TextField("Enter Podcast URL", text: $rssLink)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Load Podcast") {
                print(rssLink)
                parser.parseRSSSample()
            }
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding()
            .background(Color(red: 0, green: 0.53, blue: 0.84))
            .cornerRadius(15)
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
