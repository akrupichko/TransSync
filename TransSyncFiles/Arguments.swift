import Foundation

extension Array where Element == String {
    public func flag(for key: String) -> Bool {
        self.firstIndex(of: key) != nil
    }
    
    public mutating func url(for key: String) throws -> URL {
        try value(for: key, map: Self.urlFromString)
    }
    
    public mutating func keys(for key: String) throws -> [String] {
        try value(for: key, map: { keysString in
            keysString.split(separator: ",").map(String.init)
        })
    }
    
    public mutating func value<Arg>(for key: String, map: (String) throws -> Arg) throws -> Arg {
        guard let updatePathKeyIndex = self.firstIndex(of: key) else {
            throw TransSyncError.noArguments(key)
        }
        guard count > updatePathKeyIndex + 1 else {
            throw TransSyncError.noValueForArgument(key)
        }
        let value = try map(self[index(after: updatePathKeyIndex)])
        self.remove(at: updatePathKeyIndex)
        self.remove(at: updatePathKeyIndex)
        return value
    }
    
    private static func urlFromString(_ string: String) throws -> URL {
        guard let url = URL(string: string) else { throw TransSyncError.stringIsNotUrl(string) }
        return url
    }
}
