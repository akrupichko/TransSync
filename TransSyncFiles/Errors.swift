import Foundation

public enum TransSyncError: Error {
    case stringIsNotUrl(String)
    case noArguments(String)
    case noValueForArgument(String)
    case noMasterDirectory(String)
    case noMasterLocalizationFile(String)
    case noTranslatesDirectory(String)
    case cantOpenFile(String)
    case cantCreateTranlateFilePath(String)
}

extension TransSyncError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .stringIsNotUrl(string):
            return "Cannot convert \(string) to URL."
        case let .noArguments(key):
            return "Needs argument \"\(key)\" with value"
        case let .noValueForArgument(key):
            return "Needs value for argument \"\(key)\""
        case let .noMasterDirectory(directory):
            return "No \(directory) for update localization"
        case let .noMasterLocalizationFile(ext):
            return "No file *.\(ext) for update localization"
        case let .noTranslatesDirectory(directory):
            return "No \(directory) of actual localizations"
        case let .cantOpenFile(url):
            return "Cant open file \(url)"
        case let .cantCreateTranlateFilePath(url):
            return "Cant create tranlate file path with url: \(url)"
        }
    }
}
