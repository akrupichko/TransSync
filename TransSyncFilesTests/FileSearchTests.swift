import XCTest
@testable import TransSyncFiles

class FileSearchTests: XCTestCase {
    
    let searchedDirectoryName = "directory"
    let directoryForSearch = URL(string: "/search")!
    
    func testFileSearchSuccess() throws {
        let searchDirectories = [
            directoryForSearch.appendingPathComponent("anotherDirectory"),
            directoryForSearch.appendingPathComponent(searchedDirectoryName),
            directoryForSearch.appendingPathComponent("directory3")
        ]
        let searchFiles = [
            directoryForSearch
                .appendingPathComponent(searchedDirectoryName)
                .appendingPathComponent("local.dict"),
            directoryForSearch
                .appendingPathComponent(searchedDirectoryName)
                .appendingPathComponent("file.text")
        ]
        var filesIterator = [searchDirectories, searchFiles].makeIterator()
        let fileSearch = FileSearch(
            masterLangDirectoryName: searchedDirectoryName,
            fileExtension: "text") { url in
                filesIterator.next()!
            }
        let file = try fileSearch.masterLocalizationFile(directoryForSearch: directoryForSearch)
        
        XCTAssertEqual(file, .init(string: "/search/directory/file.text")!)
    }
}
