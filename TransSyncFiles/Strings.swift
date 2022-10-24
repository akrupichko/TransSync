import Foundation

public enum Strings {
    public static func update(
        _ text: String,
        keysToUpdate: Set<String>,
        actualTexts: [String: String]
    ) throws -> String {
        let pattern = #"^"(.*)" ?= ?"(.*)";$"#
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        
        var newLocale = ""
        let lines = text.components(separatedBy: .newlines)
        
        var unusedKeys = keysToUpdate
        lines.enumerated().forEach { index, line in
            var isValueUpdated = false
            let nsrange = NSRange(line.startIndex..<line.endIndex, in: line)
            regex.enumerateMatches(in: line, options: [], range: nsrange) { (match, _, stop) in
                guard let match = match else { return }
                guard match.numberOfRanges == 3, let firstCaptureRange = Range(match.range(at: 1), in: line)
                else { return }
                
                let key = String(line[firstCaptureRange])
                guard keysToUpdate.contains(key), let actualText = actualTexts[key]
                else { return }
                
                let newLine = line.replacingOccurrences(
                    of: #"" ?= ?"(.*)";$"#,
                    with: "\" = \"\(actualText.withEscapedSpecialChars)\";",
                    options: .regularExpression
                )
                newLocale.append(newLine)
                stop.pointee = true
                unusedKeys.remove(key)
                isValueUpdated = true
                return
            }
            if !isValueUpdated {
                newLocale.append(line)
            }
            if index < lines.endIndex - 1 {
                newLocale.append("\n")
            }
        }
        unusedKeys.forEach { key in
            guard let actualText = actualTexts[key] else { return }
            newLocale.append("\n\"\(key)\" = \"\(actualText)\";")
        }
        return newLocale
    }
}

private extension String {
    var withEscapedSpecialChars: String {
        var string = self
        string = string.replacingOccurrences(of: "\0", with: "\\\\0")
        string = string.replacingOccurrences(of: "\\", with: "\\\\")
        string = string.replacingOccurrences(of: "\t", with: "\\\\t")
        string = string.replacingOccurrences(of: "\n", with: "\\\\n")
        string = string.replacingOccurrences(of: "\r", with: "\\\\r")
        string = string.replacingOccurrences(of: "\"", with: "\\\\\"")
        return string
    }
}
