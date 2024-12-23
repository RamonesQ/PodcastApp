//
//  StringUtils.swift
//  PodcastApp
//
//  Created by Ramon Queiroz dos Santos on 23/12/24.
//

import Foundation

struct StringUtils {
    static func stripHTMLTags(from string: String) -> String {
        guard let data = string.data(using: .utf8) else { return string }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return string
        }

        return attributedString.string
    }
}
