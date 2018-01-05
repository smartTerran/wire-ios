//
// Wire
// Copyright (C) 2018 Wire Swiss GmbH
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

import XCTest
@testable import Wire

class MarkdownAttributeParserTests: XCTestCase {
    
    let sut = MarkdownAttributeParser(syntaxMap: MarkdownSyntax())
    
    func result(_ markdownArray: [(String, Markdown)]) -> String {
        // given
        let attrStr = markdownArray.attributedString
        
        // when
        return sut.parse(attrStr)
    }
    
    // MARK: - Tests
    
    func testThatItParses_Header1() {
        
        var arr = [(String, Markdown)]()
        var exp = ""
        
        arr =   [
                ("Header1", .header1)
                ]
        
        exp =   """
                # Header1\n
                """
        
        XCTAssertEqual(result(arr), exp)
        
        arr =   [
                ("Header1\n", .header1),
                ("Normal", .none)
                ]
        
        exp =   """
                # Header1
                Normal
                """
        
        XCTAssertEqual(result(arr), exp)
        
        arr =   [
                ("Normal\n", .none),
                ("Header1\n", .header1),
                ("Normal\n", .none),
                ]
        
        exp =   """
                Normal
                # Header1
                Normal
                """
        
        XCTAssertEqual(result(arr), exp)
    }
    
    func testThatItParses_Bold() {
        var arr = [(String, Markdown)]()
        var exp = ""
        
        // single
        
        arr = [
            ("Bold", .bold)
        ]
        
        exp = "**Bold**"
        
        XCTAssertEqual(result(arr), exp)
        
        // single partial
        
        arr = [
            ("Bold ", .bold),
            ("Normal", .none),
        ]
        
        exp = "**Bold **Normal"
        
        XCTAssertEqual(result(arr), exp)
        
        // single partial with extraneous *
        
        arr = [
            ("Bold", .bold),
            (" Normal*", .none),
        ]
        
        exp = "**Bold** Normal*"
        
        XCTAssertEqual(result(arr), exp)
        
        // double
        
        arr = [
            ("Bold ", .bold),
            ("Bold", .bold),
        ]
        
        exp = "**Bold Bold**"
        
        XCTAssertEqual(result(arr), exp)
        
        // single inline
        
        arr = [
            ("Normal", .none),
            ("Bold", .bold),
            ("Normal", .none),
        ]
        
        exp = "Normal**Bold**Normal"
        
        XCTAssertEqual(result(arr), exp)
    }
    
    func testThatItParses_Italic() {
        var arr = [(String, Markdown)]()
        var exp = ""
        
        // single
        
        arr = [
            ("Italic", .italic)
        ]
        
        exp = "_Italic_"
        
        XCTAssertEqual(result(arr), exp)
        
        // single partial
        
        arr = [
            ("Italic ", .italic),
            ("Normal", .none),
        ]
        
        exp = "_Italic _Normal"
        
        XCTAssertEqual(result(arr), exp)
        
        // single partial with extraneous _
        
        arr = [
            ("Italic", .italic),
            (" Normal_", .none),
        ]
        
        exp = "_Italic_ Normal_"
        
        XCTAssertEqual(result(arr), exp)
        
        // double
        
        arr = [
            ("Italic ", .italic),
            ("Italic", .italic),
        ]
        
        exp = "_Italic Italic_"
        
        XCTAssertEqual(result(arr), exp)
        
        // single inline
        
        arr = [
            ("Normal", .none),
            ("Italic", .italic),
            ("Normal", .none),
        ]
        
        exp = "Normal_Italic_Normal"
        
        XCTAssertEqual(result(arr), exp)
    }
    
}


fileprivate extension Array where Element == (String, Markdown) {
    
    // Constructs attributed string from array of (String, Markdown) tuples
    //
    var attributedString: NSMutableAttributedString {
        let attrStr = NSMutableAttributedString()
        forEach { attrStr.append(NSAttributedString(string: $0, attributes: [MarkdownAttributeName: $1])) }
        return attrStr
    }
}
