import XCTest
@testable import TransSyncFiles

class FileSyncTests: XCTestCase {
    
    let urlForUpdate = URL(string: "/Path1")!
    let urlOfActualTranslate = URL(string: "/Path2")!
    
    let sourceText = "sourceText"
    let keysForUpdate: Set<String> = ["key1", "key2"]
    let actualTranslate = ["key1": "string1"]
    let resultText = "RESULT"
    
    var firedReadUrlWithUrl = [URL]()
    var firedTranslatesToDictWithUrl = [URL]()
    var firedUpdatedTextSourceText = [String]()
    var firedUpdatedKeysToUpdate = [Set<String>]()
    var firedUpdatedActualTranslate = [[String: String]]()
    var firedSave = [String]()
    var firedSaveUrl = [URL]()
    
    func testUpdateKeysInMasterFile() throws {
        let fileSync = FileSync(
            readUrl: { url in
                self.firedReadUrlWithUrl.append(url)
                return self.sourceText
            },
            translatesToDict: { url in
                self.firedTranslatesToDictWithUrl.append(url)
                return self.actualTranslate
            },
            updatedText: { text, keysToUpdate, actualTranslate in
                self.firedUpdatedTextSourceText.append(text)
                self.firedUpdatedKeysToUpdate.append(keysToUpdate)
                self.firedUpdatedActualTranslate.append(actualTranslate)
                return self.resultText
            },
            save: { result, saveUrl  in
                self.firedSave.append(result)
                self.firedSaveUrl.append(saveUrl)
            }
        )
        
        let urlsPair = FileCompose.URLPair(
            forUpdate: urlForUpdate,
            actualTranslate: urlOfActualTranslate
        )
        try fileSync.update(urlsPair, with: keysForUpdate)
        
        XCTAssertEqual(firedReadUrlWithUrl, [urlForUpdate])
        XCTAssertEqual(firedTranslatesToDictWithUrl, [urlOfActualTranslate])
        
        XCTAssertEqual(firedUpdatedTextSourceText, [sourceText])
        XCTAssertEqual(firedUpdatedKeysToUpdate, [keysForUpdate])
        XCTAssertEqual(firedUpdatedActualTranslate, [actualTranslate])
        
        XCTAssertEqual(firedSave, [resultText])
        XCTAssertEqual(firedSaveUrl, [urlForUpdate])
    }
}
