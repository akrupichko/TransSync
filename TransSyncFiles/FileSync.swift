import Foundation

public struct FileSync {
    public typealias Text = String
    public typealias KeysToUpdate = Set<String>
    public typealias ActualTexts = [String: String]
    
    public let readUrl: (URL) throws -> String
    public let translatesToDict: (URL) throws -> [String: String]
    public let updatedText: (Text, KeysToUpdate, ActualTexts) throws -> String
    public let save: (String, URL) throws -> Void
    
    public init(
        readUrl: @escaping (URL) throws -> String,
        translatesToDict: @escaping (URL) throws -> [String: String],
        updatedText: @escaping (Text, KeysToUpdate, ActualTexts) throws -> String,
        save: @escaping (String, URL) throws -> Void
    ) {
        self.readUrl = readUrl
        self.translatesToDict = translatesToDict
        self.updatedText = updatedText
        self.save = save
    }
    
    public func update(
        _ pathForUpdate: FileCompose.URLPair,
        with keysForUpdate: Set<String>
    ) throws {
        let text = try readUrl(pathForUpdate.forUpdate)
        let actualTranslates = try translatesToDict(pathForUpdate.actualTranslate)
        let result = try updatedText(text, keysForUpdate, actualTranslates)
        try save(result, pathForUpdate.forUpdate)
    }
}

extension FileSync {
    public static func live(isFileExists: @escaping (URL) throws -> Void) -> FileSync {
        .init(
            readUrl: { try String(contentsOf: $0, encoding: .utf8) },
            translatesToDict: {
                try isFileExists($0)
                return NSDictionary(contentsOf: $0) as? [String: String] ?? [:]
            },
            updatedText: Strings.update,
            save: { try $0.write(to: $1, atomically: false, encoding: .utf8) }
        )
    }
}
