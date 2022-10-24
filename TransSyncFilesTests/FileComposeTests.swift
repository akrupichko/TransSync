import XCTest
@testable import TransSyncFiles

class FileComposeTests: XCTestCase {
    
    let fileExtension = "strings"
    let pathForUpdate = URL(string: "/Project1/Strings")!
    let pathOfActualTranslates = URL(string: "/Project2/Strings")!
    
    func testComposeUrls_SuccessPath() throws {
        var isDirectoryIterator = [true, false, true, false].makeIterator()
        let subdirs = [
            [URL(string: "/Project1/Strings/en.lproj/")!, URL(string: "/Project1/Strings/ru.lproj/")!],
            [URL(string: "/Project1/Strings/en.lproj/Localizable.strings")!],
            [URL(string: "/Project1/Strings/ru.lproj/Localizable.strings")!]
        ]
        var subdirsIterator = subdirs.makeIterator()
        let fileCompose = FileCompose(
            filtered: [],
            fileExtension: fileExtension,
            isDirectory: { _ in isDirectoryIterator.next()! },
            contentsOfDirectory: { _ in subdirsIterator.next()! }
        )

        let urlPairs = try fileCompose.findPairs(
            pathForUpdate: pathForUpdate,
            pathOfActualTranslates: pathOfActualTranslates
        )
        
        XCTAssertEqual(
            urlPairs,
            [
                .init(
                    forUpdate: URL(string: "/Project1/Strings/en.lproj/Localizable.strings")!,
                    actualTranslate: URL(string: "/Project2/Strings/en.lproj/Localizable.strings")!
                ),
                .init(
                    forUpdate: URL(string: "/Project1/Strings/ru.lproj/Localizable.strings")!,
                    actualTranslate: URL(string: "/Project2/Strings/ru.lproj/Localizable.strings")!
                )
            ]
        )
    }
    
    func testComposeUrls_Filter_SuccessPath() throws {
        var isDirectoryIterator = [true, true, false].makeIterator()
        let subdirs = [
            [URL(string: "/Project1/Strings/en.lproj/")!, URL(string: "/Project1/Strings/ru.lproj/")!],
            [URL(string: "/Project1/Strings/ru.lproj/Localizable.strings")!]
        ]
        var subdirsIterator = subdirs.makeIterator()
        let fileCompose = FileCompose(
            filtered: ["en.lproj"],
            fileExtension: fileExtension,
            isDirectory: { _ in isDirectoryIterator.next()! },
            contentsOfDirectory: { _ in subdirsIterator.next()! }
        )

        let urlPairs = try fileCompose.findPairs(
            pathForUpdate: pathForUpdate,
            pathOfActualTranslates: pathOfActualTranslates
        )
        
        XCTAssertEqual(
            urlPairs,
            [
                .init(
                    forUpdate: URL(string: "/Project1/Strings/ru.lproj/Localizable.strings")!,
                    actualTranslate: URL(string: "/Project2/Strings/ru.lproj/Localizable.strings")!
                )
            ]
        )
    }
    
    func testComposeUrls_WrongExtension() throws {
        var isDirectoryIterator = [true, false, true, false].makeIterator()
        let subdirs = [
            [URL(string: "/Project1/Strings/en.lproj/")!, URL(string: "/Project1/Strings/ru.lproj/")!],
            [URL(string: "/Project1/Strings/en.lproj/Localizable.strings")!],
            [URL(string: "/Project1/Strings/ru.lproj/Localizable.strings")!]
        ]
        var subdirsIterator = subdirs.makeIterator()
        let fileCompose = FileCompose(
            fileExtension: "exe",
            isDirectory: { _ in isDirectoryIterator.next()! },
            contentsOfDirectory: { _ in subdirsIterator.next()! }
        )

        let urlPairs = try fileCompose.findPairs(
            pathForUpdate: pathForUpdate,
            pathOfActualTranslates: pathOfActualTranslates
        )
        
        XCTAssertEqual(urlPairs, [])
    }
    
    func testComposeUrls_WithoutFiles() throws {
        var isDirectoryIterator = [true, true].makeIterator()
        let subdirs = [
            [URL(string: "/Project1/Strings/en.lproj/")!, URL(string: "/Project1/Strings/ru.lproj/")!],
            [],
            []
        ]
        var subdirsIterator = subdirs.makeIterator()
        let fileCompose = FileCompose(
            fileExtension: fileExtension,
            isDirectory: { _ in isDirectoryIterator.next()! },
            contentsOfDirectory: { _ in subdirsIterator.next()! }
        )

        let urlPairs = try fileCompose.findPairs(
            pathForUpdate: pathForUpdate,
            pathOfActualTranslates: pathOfActualTranslates
        )
        
        XCTAssertEqual(urlPairs, [])
    }
    
    func testComposeUrls_Filter_Empty() throws {
        var isDirectoryIterator = [true, false].makeIterator()
        let subdirs = [
            [URL(string: "/Project1/Strings/en.lproj/")!],
            [URL(string: "/Project1/Strings/en.lproj/Localizable.strings")!]
        ]
        var subdirsIterator = subdirs.makeIterator()
        let fileCompose = FileCompose(
            filtered: ["en.lproj"],
            fileExtension: fileExtension,
            isDirectory: { _ in isDirectoryIterator.next()! },
            contentsOfDirectory: { _ in subdirsIterator.next()! }
        )

        let urlPairs = try fileCompose.findPairs(
            pathForUpdate: pathForUpdate,
            pathOfActualTranslates: pathOfActualTranslates
        )
        
        XCTAssertEqual(urlPairs, [])
    }
}
