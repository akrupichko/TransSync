import Foundation

extension URL {
    public var isDirectory: Bool {
       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
    
    func replaceWith(_ urlForReplace: URL, actualTranslateUrl: URL) throws -> URL {
        let path = self.absoluteString.replacingOccurrences(
            of: urlForReplace.absoluteString,
            with: actualTranslateUrl.absoluteString
        )
        guard let url = URL(string: path) else {
            throw TransSyncError.cantCreateTranlateFilePath(path)
        }
        return url
    }
}
