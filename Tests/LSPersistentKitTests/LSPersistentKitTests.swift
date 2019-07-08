import XCTest
@testable import LSPersistentKit

final class LSPersistentKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LSPersistentKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
