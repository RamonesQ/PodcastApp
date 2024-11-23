//
//  RSSParser.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/11/24.
//

import Foundation

class RSSParser {
    
    func parseRSSSample() {
        guard let path = Bundle.main.path(forResource: "rssSample", ofType: "rss") else {
            print("Error: File not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let parser = Foundation.XMLParser(data: data)
            let delegate = RSSParserDelegate()
            parser.delegate = delegate
            
            if parser.parse() {
                print("Parsing successful")
                print(delegate.parsedData)
            } else {
                print("Error parsing XML")
            }
        } catch {
            print("Error reading file: \(error)")
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
            parsedData[currentElement] = currentValue.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}

