import Foundation

public enum Mode: Equatable {
    case tryGetKeysForUpdateFromMasterFile(Paths)
    case startWithKeysForUpdate(keys: [String], Paths)
    case help
}

extension Mode {
    public struct Paths: Equatable {
        public let pathForUpdate: URL
        public let pathOfActualTranslates: URL
    }
}

extension Mode {
    public init(arguments: [String]) throws {
        var arguments = arguments
        let helpFlag = arguments.flag(for: "-h")
        if helpFlag {
            self = .help
            return
        }
        
        let updatePath: URL = try arguments.url(for: "-u")
        let translatesPath: URL = try arguments.url(for: "-t")
        let keysForUpdate: [String]?
        do {
            keysForUpdate = try arguments.keys(for: "-k")
        } catch TransSyncError.noArguments("-k") {
            keysForUpdate = nil
        }
        let paths = Paths(
            pathForUpdate: updatePath,
            pathOfActualTranslates: translatesPath
        )
        if let keysForUpdate = keysForUpdate {
            self = .startWithKeysForUpdate(keys: keysForUpdate, paths)
            return
        }
        self = .tryGetKeysForUpdateFromMasterFile(paths)
    }
}
