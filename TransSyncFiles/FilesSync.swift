import Foundation

public struct FilesSync {
    public typealias LangDirectory = String
    public typealias PathForUpdate = URL
    public typealias PathOfActualTranslates = URL
    public typealias KeysForUpdate = Set<String>
    
    public let findPairsForCopy: (LangDirectory, PathForUpdate) throws -> [FileCompose.URLPair]
    public let findPairs: (PathForUpdate, PathOfActualTranslates) throws -> [FileCompose.URLPair]
    public let update: (FileCompose.URLPair, KeysForUpdate) throws -> Void
    
    public init(
        findPairsForCopy: @escaping (LangDirectory, PathForUpdate) throws -> [FileCompose.URLPair],
        findPairs: @escaping (PathForUpdate, PathOfActualTranslates) throws -> [FileCompose.URLPair],
        update: @escaping (FileCompose.URLPair, KeysForUpdate) throws -> Void
    ) {
        self.findPairsForCopy = findPairsForCopy
        self.findPairs = findPairs
        self.update = update
    }
    
    public func sync(keys: Set<String>, paths: Mode.Paths) throws {
        let pairs = try findPairs(paths.pathForUpdate, paths.pathOfActualTranslates)
        try pairs.forEach {
            try update($0, keys)
        }
    }
    
    public func copy(from: FilesSync.LangDirectory, keys: Set<String>, pathForUpdate: URL) throws {
        let pairs = try findPairsForCopy(from, pathForUpdate)
        try pairs.forEach {
            try update($0, keys)
        }
    }
}
