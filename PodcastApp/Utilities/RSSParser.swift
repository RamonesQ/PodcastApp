//
//  RSSParser.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation

class RSSParser: NSObject, XMLParserDelegate {
    private var currentElement = ""
    private var currentValue = ""
    private var episode: Episode?
    private var language = ""
    private var author = ""

    func parse(data: Data) -> (Episode?, String, String)? {
        let parser = XMLParser(data: data)
        parser.delegate = self
        
        if parser.parse() {
            return (episode, language, author)
        } else {
            return nil
        }
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        currentValue = ""
        
        if elementName == "item" && episode == nil {
            episode = Episode()
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue += string
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let value = currentValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch elementName {
        case "title": episode?.title = value
        case "description": episode?.description = value
        case "pubDate": episode?.publishDate = value
        case "itunes:duration": episode?.duration = value
        case "guid": episode?.guid = value
        case "itunes:season": episode?.season = Int(value) ?? 0
        case "itunes:episode": episode?.episodeNumber = Int(value) ?? 0
        case "itunes:episodeType": episode?.episodeType = value
        case "language": language = value
        case "itunes:author": author = value
        default: break
        }
    }
}
