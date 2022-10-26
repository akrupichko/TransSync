import XCTest
@testable import TransSyncFiles

class FilesSyncTests: XCTestCase {
    
    let pathForUpdateURL = URL(string: "/update/path")!
    let translatesURL = URL(string: "/translates/path")!
    
    func testFilesSyncDependenciesFired() throws {
        var firedUpdateWithUrls = [FileCompose.URLPair]()
        var firedUpdateWithKeys = [Set<String>]()
        
        let filesSync = FilesSync { _, _ in
            return []
        } findPairs: { updateUrl, translatesUrl in
            return [
                .init(
                    forUpdate: updateUrl.appendingPathComponent("en"),
                    actualTranslate: translatesUrl.appendingPathComponent("en")
                ),
                .init(
                    forUpdate: updateUrl.appendingPathComponent("az"),
                    actualTranslate: translatesUrl.appendingPathComponent("az")
                )
            ]
        } update: { urls, keys in
            firedUpdateWithUrls.append(urls)
            firedUpdateWithKeys.append(keys)
        }
        try filesSync.sync(
            keys: ["key1", "key2"],
            paths: .init(
                pathForUpdate: pathForUpdateURL,
                pathOfActualTranslates: translatesURL
            )
        )
        XCTAssertEqual(
            firedUpdateWithUrls,
            [
                .init(
                    forUpdate: .init(string: "/update/path/en")!,
                    actualTranslate: .init(string: "/translates/path/en")!
                ),
                .init(
                    forUpdate: .init(string: "/update/path/az")!,
                    actualTranslate: .init(string: "/translates/path/az")!
                )
            ]
        )
        XCTAssertEqual(
            firedUpdateWithKeys,
            [
                ["key1", "key2"],
                ["key1", "key2"]
            ]
        )
    }
    
    func testFilesCopyDependenciesFired() throws {
        let langDirectoryName = "en"
        var firedUpdateWithUrls = [FileCompose.URLPair]()
        var firedUpdateWithKeys = [Set<String>]()
        
        let filesSync = FilesSync { langDirectoryName, updateUrl in
            return [
                .init(
                    forUpdate: updateUrl.appendingPathComponent("en"),
                    actualTranslate: updateUrl.appendingPathComponent(langDirectoryName)
                ),
                .init(
                    forUpdate: updateUrl.appendingPathComponent("az"),
                    actualTranslate: updateUrl.appendingPathComponent(langDirectoryName)
                )
            ]
        } findPairs: { updateUrl, translatesUrl in
            return []
        } update: { urls, keys in
            firedUpdateWithUrls.append(urls)
            firedUpdateWithKeys.append(keys)
        }
        try filesSync.copy(
            from: langDirectoryName,
            keys: ["key1", "key2"],
            pathForUpdate: pathForUpdateURL
        )
        XCTAssertEqual(
            firedUpdateWithUrls,
            [
                .init(
                    forUpdate: .init(string: "/update/path/en")!,
                    actualTranslate: .init(string: "/update/path/en")!
                ),
                .init(
                    forUpdate: .init(string: "/update/path/az")!,
                    actualTranslate: .init(string: "/update/path/en")!
                )
            ]
        )
        XCTAssertEqual(
            firedUpdateWithKeys,
            [
                ["key1", "key2"],
                ["key1", "key2"]
            ]
        )
    }
}
