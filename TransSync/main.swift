import Foundation
import TransSyncFiles

let arguments = Array<String>(CommandLine.arguments.dropFirst())

do {
    try TransSyncFiles.live(arguments: arguments).run()
} catch {
    print("\u{26D4} \u{001B}[0;31m" + error.localizedDescription)
}
