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
        return parser.parse() ? podcast : nil
    }

    // MARK: - XMLParserDelegate

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        currentValue = ""

        switch elementName {
        case "channel":
            initializePodcast()
        case "item":
            currentEpisode = Episode()
        case "itunes:image":
            handleImageURL(attributeDict["href"])
        case "enclosure":
            currentEpisode?.audioURL = attributeDict["url"] ?? ""
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
        case "title", "description":
            setPodcastOrEpisodeValue(for: elementName, value: value)
        case "itunes:author", "language":
            setPodcastValue(for: elementName, value: value)
        case "itunes:explicit":
            podcast?.explicit = value.lowercased() == "yes" || value.lowercased() == "true"
        case "pubDate", "itunes:duration", "guid", "itunes:episodeType":
            setEpisodeValue(for: elementName, value: value)
        case "itunes:season", "itunes:episode":
            setEpisodeIntValue(for: elementName, value: value)
        case "item":
            finishCurrentEpisode()
        default:
            break
        }
    }

    // MARK: - Helper Methods

    private func initializePodcast() {
        podcast = Podcast()
    }

    private func handleImageURL(_ url: String?) {
        if let url = url {
            if currentEpisode != nil {
                currentEpisode?.imageURL = url
            } else {
                podcast?.imageURL = url
            }
        }
    }

    private func setPodcastOrEpisodeValue(for elementName: String, value: String) {
        if currentEpisode != nil {
            setEpisodeValue(for: elementName, value: value)
        } else {
            setPodcastValue(for: elementName, value: value)
        }
    }

    private func setPodcastValue(for elementName: String, value: String) {
        switch elementName {
        case "title":
            podcast?.title = value
        case "description":
            podcast?.description = StringUtils.stripHTMLTags(from: value)
        case "itunes:author":
            podcast?.author = value
        case "language":
            podcast?.language = value
        default:
            break
        }
    }

    private func setEpisodeValue(for elementName: String, value: String) {
        switch elementName {
        case "title":
            currentEpisode?.title = value
        case "description":
            currentEpisode?.description = StringUtils.stripHTMLTags(from: value)
        case "pubDate":
            currentEpisode?.publishDate = value
        case "itunes:duration":
            currentEpisode?.duration = value
        case "guid":
            currentEpisode?.guid = value
        case "itunes:episodeType":
            currentEpisode?.episodeType = value
        default:
            break
        }
    }

    private func setEpisodeIntValue(for elementName: String, value: String) {
        if let intValue = Int(value) {
            switch elementName {
            case "itunes:season":
                currentEpisode?.season = intValue
            case "itunes:episode":
                currentEpisode?.episodeNumber = intValue
            default:
                break
            }
        }
    }

    private func finishCurrentEpisode() {
        if let episode = currentEpisode {
            podcast?.episodes.append(episode)
            currentEpisode = nil
        }
    }
}
