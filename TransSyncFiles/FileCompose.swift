import Foundation

public struct FileCompose {
    public struct URLPair: Equatable {
        public let forUpdate: URL
        public let actualTranslate: URL
    }
    
    public let filtered: Set<String>
    public let fileExtension: String
    public let isDirectory: (URL) -> Bool
    public let contentsOfDirectory: (URL) throws -> [URL]
    
    public init(
        filtered: Set<String> = ["en.lproj"],
        fileExtension: String = "strings",
        isDirectory: @escaping (URL) -> Bool,
        contentsOfDirectory: @escaping (URL) throws -> [URL]
    ) {
        self.filtered = filtered
        self.fileExtension = fileExtension
        self.isDirectory = isDirectory
        self.contentsOfDirectory = contentsOfDirectory
    }
    
    public func findPairs(
        pathForUpdate: URL,
        pathOfActualTranslates: URL
    ) throws -> [URLPair] {
        try findFilesWithTranslate(path: pathForUpdate)
            .map {
                .init(
                    forUpdate: $0,
                    actualTranslate: try $0.replaceWith(
                        pathForUpdate,
                        actualTranslateUrl: pathOfActualTranslates
                    )
                )
            }
    }
    
    private func findFilesWithTranslate(path: URL) throws -> [URL] {
        guard !filtered.contains(path.lastPathComponent) else { return [] }
        
        var files = [URL]()
        let content = try contentsOfDirectory(path)

        try content.forEach { url in
            if isDirectory(url) {
                files.append(contentsOf: try findFilesWithTranslate(path: url))
            } else if url.lastPathComponent.components(separatedBy: ".").last == fileExtension {
                files.append(url)
            }
        }
        return files
    }
}
