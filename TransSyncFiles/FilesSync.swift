import Foundation

public struct FilesSync {
    public typealias PathForUpdate = URL
    public typealias PathOfActualTranslates = URL
    public typealias KeysForUpdate = Set<String>
    
    public let findPairs: (PathForUpdate, PathOfActualTranslates) throws -> [FileCompose.URLPair]
    public let update: (FileCompose.URLPair, KeysForUpdate) throws -> Void
    
    public init(
        findPairs: @escaping (PathForUpdate, PathOfActualTranslates) throws -> [FileCompose.URLPair],
        update: @escaping (FileCompose.URLPair, KeysForUpdate) throws -> Void
    ) {
        self.findPairs = findPairs
        self.update = update
    }
    
    public func sync(keys: Set<String>, paths: Mode.Paths) throws {
        let pairs = try findPairs(paths.pathForUpdate, paths.pathOfActualTranslates)
        try pairs.forEach {
            try update($0, keys)
        }
    }
}
