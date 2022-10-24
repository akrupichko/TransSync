import XCTest
@testable import TransSyncFiles

class ArgumentsParserTests: XCTestCase {
    
    func testWithKeyAndUrlArgument() throws {
        var input = ["-input", "/users/dir", "ssss", "qqqqq"]
        XCTAssertEqual(try input.url(for: "-input"), URL(string: "/users/dir"))
    }
    
    func testWithKeyAndWithoutArgument() throws {
        var input = ["-input1"]
        do {
            _ = try input.url(for: "-input")
            XCTFail("Founded url, but here no urls in arguments")
        } catch TransSyncError.noArguments("-input") {
            return
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testWithKeyAndWithoutUrlArgument() throws {
        var input = ["-input"]
        do {
            _ = try input.url(for: "-input")
            XCTFail("Founded url, but here no urls in arguments")
        } catch TransSyncError.noValueForArgument("-input") {
            return
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testWithKeyAndKeysArgument() throws {
        var input = ["-input", "q,s,w,l", "ssss", "qqqqq"]
        XCTAssertEqual(try input.keys(for: "-input"), ["q","s","w","l"])
    }
}
