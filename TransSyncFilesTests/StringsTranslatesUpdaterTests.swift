import XCTest
@testable import TransSyncFiles

class StringsTranslatesUpdaterTests: XCTestCase {
    
    func testUpdateKeysInMasterFile() throws {
        let keysInMasterFile: Set<String> = [
            "string1",
            "string2"
        ]
        let actualLocalization = [
            "string1": "updatedTranslate1",
            "string2": "updatedTranslate2\nnewline'"
        ]
        let text = """

"string1" = "translate1";
// Comment
"string2" = "translate2";
"""
        
        let updatedText = try Strings.update(
            text,
            keysToUpdate: keysInMasterFile,
            actualTexts: actualLocalization
        )
        
        XCTAssertEqual(
            updatedText,
            """

"string1" = "updatedTranslate1";
// Comment
"string2" = "updatedTranslate2\\nnewline'";
"""
        )
    }
    
    func testUpdateExistingKeysInMasterFile() throws {
        let keysInMasterFile: Set<String> = [
            "string1",
            "string2"
        ]
        let actualLocalization = [
            "string1": "updatedTranslate1",
            "string2": "updatedTranslate2",
            "string3": "updatedTranslate3"
        ]
        let text = """
"string1" = "translate1";
"string2" = "translate2";
"string3" = "translate3";
"""
        
        let updatedText = try Strings.update(
            text,
            keysToUpdate: keysInMasterFile,
            actualTexts: actualLocalization
        )
        
        XCTAssertEqual(
            updatedText,
            """
"string1" = "updatedTranslate1";
"string2" = "updatedTranslate2";
"string3" = "translate3";
"""
        )
    }
    
    func testAddNewStrings_IfExistsInKeys_AndActualLocalization() throws {
        let keysInMasterFile: Set<String> = [
            "string1",
            "string2",
            "string4"
        ]
        let actualLocalization = [
            "string1": "updatedTranslate1",
            "string2": "updatedTranslate2",
            "string3": "updatedTranslate3",
            "string4": "updatedTranslate4"
        ]
        let text = """
"string1" = "translate1";
"string2" = "translate2";
"string3" = "translate3";
"""
        
        let updatedText = try Strings.update(
            text,
            keysToUpdate: keysInMasterFile,
            actualTexts: actualLocalization
        )
        
        XCTAssertEqual(
            updatedText,
            """
"string1" = "updatedTranslate1";
"string2" = "updatedTranslate2";
"string3" = "translate3";
"string4" = "updatedTranslate4";
"""
        )
    }
}
