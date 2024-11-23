//
//  RSSParser.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation

class RSSParser {
    func parseRSSSample() -> (Episode, String, String)? {
        guard let path = Bundle.main.path(forResource: "rssSample", ofType: "rss") else {
            print("Error: File not found")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let parser = Foundation.XMLParser(data: data)
            let delegate = RSSParserDelegate()
            parser.delegate = delegate
            
            if parser.parse() {
                print("Parsing successful")
                let episode = delegate.createEpisode()
                let language = delegate.parsedData["language"] ?? ""
                let author = delegate.parsedData["itunes:author"] ?? ""
                return (episode, language, author)
            } else {
                print("Error parsing XML")
                return nil
            }
        } catch {
            print("Error reading file: \(error)")
            return nil
        }
    }
}

class RSSParserDelegate: NSObject, XMLParserDelegate {
    var currentElement = ""
    var currentValue = ""
    var parsedData: [String: String] = [:]
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        currentValue = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !currentValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            parsedData[elementName] = currentValue.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    func createEpisode() -> Episode {
        return Episode(
            title: parsedData["itunes:title"] ?? "",
            description: parsedData["description"] ?? "",
            publishDate: parsedData["pubDate"] ?? "",
            duration: parsedData["itunes:duration"] ?? "",
            guid: parsedData["guid"] ?? "",
            season: Int(parsedData["itunes:season"] ?? "") ?? 0,
            episodeNumber: Int(parsedData["itunes:episode"] ?? "") ?? 0,
            episodeType: parsedData["itunes:episodeType"] ?? ""
        )
    }
}
