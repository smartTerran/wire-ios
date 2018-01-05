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

class MarkdownSyntaxParserTests: XCTestCase {
    
    let sut = MarkdownSyntaxParser(style: MarkdownStyle())
    
    func test(inputString: String, expectedString: String, markdownIndicies: [(Int, Markdown)]) {
        // given
        let syntaxString = NSMutableAttributedString(string: inputString)
        
        // when
        let result = self.sut.parse(syntaxString)
        
        // then
        XCTAssertEqual(result.string, expectedString)
        
        markdownIndicies.forEach {
            let markdown = result.attribute(MarkdownAttributeName, at: $0, effectiveRange: nil) as? Markdown
            XCTAssertEqual(markdown ?? .none, $1)
        }
    }
    
    // MARK: - Simple
    
    func testThatItParses_Header() {
        test(inputString: "# Header\n", expectedString: "Header\n", markdownIndicies: [(0, .header1)])
        test(inputString: "# Header\nNormal", expectedString: "Header\nNormal", markdownIndicies: [(0, .header1), (7, .none)])
        test(inputString: "Normal\n# Header\nNormal", expectedString: "Normal\nHeader\nNormal", markdownIndicies: [(0, .none), (7, .header1), (14, .none)])
        
        test(inputString: "## Header\n", expectedString: "Header\n", markdownIndicies: [(0, .header2)])
        test(inputString: "## Header\nNormal", expectedString: "Header\nNormal", markdownIndicies: [(0, .header2), (7, .none)])
        test(inputString: "Normal\n## Header\nNormal", expectedString: "Normal\nHeader\nNormal", markdownIndicies: [(0, .none), (7, .header2), (14, .none)])
        
        test(inputString: "### Header\n", expectedString: "Header\n", markdownIndicies: [(0, .header3)])
        test(inputString: "### Header\nNormal", expectedString: "Header\nNormal", markdownIndicies: [(0, .header3), (7, .none)])
        test(inputString: "Normal\n### Header\nNormal", expectedString: "Normal\nHeader\nNormal", markdownIndicies: [(0, .none), (7, .header3), (14, .none)])
    }
    
    func testThatItParses_Bold() {
        test(inputString: "**Bold**", expectedString: "Bold", markdownIndicies: [(0, .bold)])
        test(inputString: "**Bold** Normal", expectedString: "Bold Normal", markdownIndicies: [(0, .bold), (4, .none)])
        test(inputString: "**Bold** Normal **Bold**", expectedString: "Bold Normal Bold", markdownIndicies: [(0, .bold), (4, .none), (12, .bold)])
        test(inputString: "Normal **Bold** Normal **Bold**", expectedString: "Normal Bold Normal Bold", markdownIndicies: [(0, .none), (7, .bold), (11, .none), (19, .bold)])
        
        test(inputString: "Normal **Bold** Normal*", expectedString: "Normal Bold Normal*", markdownIndicies: [(0, .none), (7,.bold), (11, .none)])
    }
    
    func testThatItParses_Italic() {
        XCTFail()
    }
    
    func testThatItParses_Code() {
        XCTFail()
    }
    
    // MARK: - Combined
    
    func testThatItParses_BoldItalic() {
        XCTFail()
    }
    
    func testThatItParses_Lists() {
        XCTFail()
    }
    
    func testThatItParses_ListsBold() {
        XCTFail()
    }
    
    func testThatItParses_ListsItalic() {
        XCTFail()
    }
    
    func testThatItParses_ListsCode() {
        XCTFail()
    }
    
    // MARK: - Mixed
    
    func testThatItParses_MultipleMarkdown() {
        XCTFail()
    }
}
