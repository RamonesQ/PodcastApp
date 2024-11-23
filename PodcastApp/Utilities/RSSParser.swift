//
//  RSSParser.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation


protocol RSSParserProtocol {
    func parse(data: Data) -> Podcast?
}

class RSSParser: NSObject, XMLParserDelegate, RSSParserProtocol {
    private var currentElement = ""
    private var currentValue = ""
    private var podcast: Podcast?
    private var currentEpisode: Episode?

    func parse(data: Data) -> Podcast? {
        let parser = XMLParser(data: data)
        parser.delegate = self
        
        if parser.parse() {
            return podcast
        } else {
            return nil
        }
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        currentValue = ""
        
        switch elementName {
        case "channel":
            podcast = Podcast(id: UUID(), title: "", description: "", author: "", language: "", imageURL: "", explicit: false, episodes: [])
        case "item":
            currentEpisode = Episode()
        case "itunes:image":
            if let url = attributeDict["href"] {
                if currentEpisode != nil {
                    currentEpisode?.imageURL = url
                } else {
                    podcast?.imageURL = url
                }
            }
        case "enclosure":
            if let url = attributeDict["url"] {
                currentEpisode?.audioURL = url
            }
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue += string
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let value = currentValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch elementName {
        case "title":
            if currentEpisode != nil {
                currentEpisode?.title = value
            } else {
                podcast?.title = value
            }
        case "description":
            if currentEpisode != nil {
                currentEpisode?.description = value
            } else {
                podcast?.description = value
            }
        case "itunes:author":
            podcast?.author = value
        case "language":
            podcast?.language = value
        case "itunes:explicit":
            podcast?.explicit = (value.lowercased() == "yes" || value.lowercased() == "true")
        case "pubDate":
            currentEpisode?.publishDate = value
        case "itunes:duration":
            currentEpisode?.duration = value
        case "guid":
            currentEpisode?.guid = value
        case "itunes:season":
            currentEpisode?.season = Int(value) ?? 0
        case "itunes:episode":
            currentEpisode?.episodeNumber = Int(value) ?? 0
        case "itunes:episodeType":
            currentEpisode?.episodeType = value
        case "item":
            if let episode = currentEpisode {
                podcast?.episodes.append(episode)
                currentEpisode = nil
            }
        default:
            break
        }
    }
}
