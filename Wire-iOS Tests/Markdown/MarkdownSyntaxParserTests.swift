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
    
    // MARK: - Simple
    
    func testThatItParses_Header() {
        
        let test: (String, String, [(Int, Markdown)]) -> Void = { input, expectedStr, markdownIndices in
            // given
            let syntaxString = NSMutableAttributedString(string: input)
            
            // when
            let result = self.sut.parse(syntaxString)
            
            // then
            XCTAssertEqual(result.string, expectedStr)
            
            markdownIndices.forEach {
                let markdown = result.attribute(MarkdownAttributeName, at: $0, effectiveRange: nil) as? Markdown
                XCTAssertEqual(markdown ?? .none, $1)
            }
        }
        
        test("# Header\n", "Header\n", [(0, .header1)])
        test("# Header\nNormal", "Header\nNormal", [(0, .header1), (7, .none)])
        test("Normal\n# Header\nNormal", "Normal\nHeader\nNormal", [(0, .none), (7, .header1), (14, .none)])
        
        test("## Header\n", "Header\n", [(0, .header2)])
        test("## Header\nNormal", "Header\nNormal", [(0, .header2), (7, .none)])
        test("Normal\n## Header\nNormal", "Normal\nHeader\nNormal", [(0, .none), (7, .header2), (14, .none)])
        
        test("### Header\n", "Header\n", [(0, .header3)])
        test("### Header\nNormal", "Header\nNormal", [(0, .header3), (7, .none)])
        test("Normal\n### Header\nNormal", "Normal\nHeader\nNormal", [(0, .none), (7, .header3), (14, .none)])
    }
    
    func testThatItParses_Bold() {
        XCTFail()
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
