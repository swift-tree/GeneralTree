import XCTest

#if !canImport(ObjectiveC)
  public func allTests() -> [XCTestCaseEntry] {
    [
      testCase(GeneralTreeTests.allTests),
    ]
  }
#endif
