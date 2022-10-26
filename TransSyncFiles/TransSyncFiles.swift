import Foundation

public struct TransSyncFiles {
    let masterLangDirectory: String
    let stringsExtension: String
    let arguments: [String]
    let filesSync: FilesSync
    let fileSearch: FileSearch
}

extension TransSyncFiles {
    public func run() throws {
        let mode = try Mode(arguments: arguments)

        switch mode {
        case .tryGetKeysForUpdateFromMasterFile(let paths):
            let masterLocalizationFile = try fileSearch.masterLocalizationFile(
                directoryForSearch: paths.pathForUpdate
            )

            let dictionaryForUpdate = NSDictionary(contentsOf: masterLocalizationFile) as? [String: String] ?? [:]
            let keysForUpdate = Set<String>(dictionaryForUpdate.compactMap { key, _ in key })
            
            try filesSync.sync(keys: keysForUpdate, paths: paths)
            print("\u{2705} \u{001B}[0;32mSUCCESS")
        case .startWithKeysForUpdate(let keys, let paths):
            try filesSync.sync(keys: Set(keys), paths: paths)
            print("\u{2705} \u{001B}[0;32mSUCCESS")
        case .help:
            print(String.helpString)
        case .copyFromMainLocaleToAll(let keys, let url):
            try filesSync.copy(from: masterLangDirectory, keys: Set(keys), pathForUpdate: url)
            print("\u{2705} \u{001B}[0;32mSUCCESS")
        }
    }
}

extension TransSyncFiles {
    public static func live(arguments: [String]) -> TransSyncFiles {
        let fileManager = FileManager()
        let masterLangDirectory = "en.lproj"
        let stringsExtension = "strings"
        
        let fileSync = FileSync.live() {
            guard fileManager.fileExists(atPath: $0.path) else {
                throw TransSyncError.cantOpenFile($0.absoluteString)
            }
        }
        let fileCompose = FileCompose(
            filtered: [masterLangDirectory],
            fileExtension: stringsExtension,
            isDirectory: { $0.isDirectory },
            contentsOfDirectory: { try fileManager.contentsOfDirectory(at: $0, includingPropertiesForKeys: nil) }
        )
        
        return TransSyncFiles(
            masterLangDirectory: masterLangDirectory,
            stringsExtension: stringsExtension,
            arguments: arguments,
            filesSync: FilesSync(
                findPairsForCopy: fileCompose.findPairsForCopy,
                findPairs: fileCompose.findPairs,
                update: fileSync.update
            ),
            fileSearch: FileSearch(
                masterLangDirectoryName: masterLangDirectory,
                fileExtension: stringsExtension,
                contentsOfDirectory: {
                    try fileManager.contentsOfDirectory(at: $0, includingPropertiesForKeys: nil)
                }
            )
        )
    }
}
