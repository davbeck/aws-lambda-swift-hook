import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(aws_lambda_swift_hookTests.allTests),
    ]
}
#endif