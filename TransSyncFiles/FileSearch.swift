import Foundation

public struct FileSearch {
    public let masterLangDirectoryName: String
    public let fileExtension: String
    public let contentsOfDirectory: (URL) throws -> [URL]
    
    public init(
        masterLangDirectoryName: String,
        fileExtension: String,
        contentsOfDirectory: @escaping (URL) throws -> [URL]
    ) {
        self.masterLangDirectoryName = masterLangDirectoryName
        self.fileExtension = fileExtension
        self.contentsOfDirectory = contentsOfDirectory
    }
}

extension FileSearch {
    public func masterLocalizationFile(directoryForSearch: URL) throws -> URL {
        let updateSubpaths = try contentsOfDirectory(directoryForSearch)
        let masterDirectory = updateSubpaths.first { $0.lastPathComponent == masterLangDirectoryName }

        guard let masterDirectory = masterDirectory else {
            throw TransSyncError.noMasterDirectory(masterLangDirectoryName)
        }

        let masterDirectorySubpaths = try contentsOfDirectory(masterDirectory)
        let masterLocalizationFile = masterDirectorySubpaths.first {
            $0.lastPathComponent.split(separator: ".").last ?? "" == fileExtension
        }

        guard let masterLocalizationFile = masterLocalizationFile else {
            throw TransSyncError.noMasterLocalizationFile(fileExtension)
        }
        return masterLocalizationFile
    }
}
