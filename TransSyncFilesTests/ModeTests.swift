import XCTest
@testable import TransSyncFiles

class ModeTests: XCTestCase {
    
    func testHelpMode() throws {
        let mode = try Mode(arguments: ["-input", "/users/dir", "-h"])
        XCTAssertEqual(mode, .help)
    }
    
    func testGetKeysForUpdateFromMasterFile_Success() throws {
        let mode = try Mode(arguments: ["-u", "/update/dir", "-t", "/translates/dir"])
        XCTAssertEqual(
            mode,
            .tryGetKeysForUpdateFromMasterFile(
                .init(
                    pathForUpdate: .init(string: "/update/dir")!,
                    pathOfActualTranslates: .init(string: "/translates/dir")!
                )
            )
        )
    }
    
    func testGetKeysForUpdateFromMasterFile_Fail_no_translate_dir() throws {
        do {
            _ = try Mode(arguments: ["-u", "/update/dir"])
            XCTFail("Wrong mode")
        } catch TransSyncError.noArguments("-t") {
            return
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetKeysForUpdateFromMasterFile_Fail_no_update_arg() throws {
        do {
            _ = try Mode(arguments: ["-u", "-t", "/translates/dir"])
            XCTFail("Wrong mode")
        } catch TransSyncError.noArguments("-t") {
            return
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testStartWithKeysForUpdate_Success() throws {
        let mode = try Mode(arguments: ["-u", "/update/dir", "-t", "/translates/dir", "-k", "q,s,w,l"])
        XCTAssertEqual(
            mode,
            .startWithKeysForUpdate(
                keys: ["q","s","w","l"],
                .init(
                    pathForUpdate: .init(string: "/update/dir")!,
                    pathOfActualTranslates: .init(string: "/translates/dir")!
                )
            )
        )
    }
    
    func testStartWithKeysForUpdate_Fail_no_value() throws {
        do {
            _ = try Mode(arguments: ["-u", "/update/dir", "-t", "/translates/dir", "-k"])
            XCTFail("Wrong mode")
        } catch TransSyncError.noValueForArgument("-k") {
            return
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
