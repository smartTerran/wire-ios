//
// Wire
// Copyright (C) 2017 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

class MarkdownSyntaxParser {
    
    var style: MarkdownStyle
    
    init(style: MarkdownStyle) {
        self.style = style
    }
    
    private lazy var matchers: [Matcher] = {
        var result = [Matcher]()
        
        let headerMatcher: (Int) -> Matcher = { level in
            let pattern: String
            let markdown: Markdown
            
            switch level {
            case 1:
                pattern = header1Pattern
                markdown = .header1
            case 2:
                pattern = header2Pattern
                markdown = .header2
            default:
                pattern = header3Pattern
                markdown = .header3
            }
            
            return Matcher(pattern: pattern, options: .anchorsMatchLines, stylingBlock: { attrStr, match in
                guard match.numberOfRanges == 3 else { return }
                let syntaxRange = match.rangeAt(1)
                let contentRange = match.rangeAt(2)
                attrStr.addAttribute(MarkdownAttributeName, value: Markdown.syntax, range: syntaxRange)
                attrStr.setAttributes(self.style.attributes(for: markdown), range: contentRange)
            })
        }
        
        result = [headerMatcher(1), headerMatcher(2), headerMatcher(3)]
        
        return result 
    }()
    
    /// Returns an attributed string constructed by the given syntax string.
    ///
    func parse(_ syntaxString: NSMutableAttributedString) -> NSMutableAttributedString {
        
        matchers.forEach { $0.match(string: syntaxString) }
        return stripSyntax(syntaxString)
    }
    
    private func stripSyntax(_ string: NSMutableAttributedString) -> NSMutableAttributedString {
        var ranges = [NSRange]()
        let wholeRange = NSMakeRange(0, string.length)
        
        // get ranges of all syntax
        string.enumerateAttribute(MarkdownAttributeName, in: wholeRange, options: .reverse) { val, range, _ in
            if let markdown = val as? Markdown, markdown == .syntax {
                ranges.append(range)
            }
        }
        
        // remove the syntax
        ranges.forEach { string.replaceCharacters(in: $0, with: "") }
        
        return string
    }
}

private class Matcher {
    
    let regex: NSRegularExpression
    let stylingBlock: (NSMutableAttributedString, NSTextCheckingResult) -> Void
    
    init(pattern: String, options: NSRegularExpression.Options, stylingBlock: @escaping (NSMutableAttributedString, NSTextCheckingResult) -> Void) {
        
        self.stylingBlock = stylingBlock
        
        do {
            try self.regex = NSRegularExpression(pattern: pattern, options: options)
        } catch let error {
            fatal("Could not create Regular Expression: \(error.localizedDescription)")
        }
    }
    
    func match(string: NSMutableAttributedString) {
        let wholeRange = NSMakeRange(0, string.length)
        
        regex.enumerateMatches(in: string.string, options: [], range: wholeRange) { match, flags, _ in
            if let match = match {
                self.stylingBlock(string, match)
            }
        }
    }
}

private let header1Pattern = "(^\\#{1}[\\t ]+)(.*)$"
private let header2Pattern = "(^\\#{2}[\\t ]+)(.*)$"
private let header3Pattern = "(^\\#{3}[\\t ]+)(.*)$"
private let boldPattern = "(\\*{2})(.+)(\\1)"
private let italicPattern = "(\\_)(.+)(\\1)"
