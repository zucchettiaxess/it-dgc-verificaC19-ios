import XCTest
@testable import VerificaC19

extension XCTestCase {
    public func wait(_ seconds: TimeInterval) {
        let waitExpectation = self.expectation(description: "waiting")
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            waitExpectation.fulfill()
        }
        wait(for: [waitExpectation], timeout: seconds + 1)
    }

    public func wait(for expectations: [XCTestExpectation], expectationsTimeout: Double = 10) {
        wait(for: expectations, timeout: expectationsTimeout)
    }
    
    public func wait(condition: @escaping () -> Bool, timeout: Double = 10, message: String = "", file: StaticString = #file, line: UInt = #line) {
        var isSuccess = false
        let observer = CFRunLoopObserverCreateWithHandler(nil, CFRunLoopActivity.beforeWaiting.rawValue, true, 0) { _, _ in
            isSuccess = condition()
            if isSuccess {
                CFRunLoopStop(CFRunLoopGetCurrent())
            }
        }
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, .defaultMode)
        
        let timer = CFRunLoopTimerCreate(nil, CFAbsoluteTimeGetCurrent(), 0.1, 0, 0, nil, nil)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, .defaultMode)
        
        CFRunLoopRunInMode(.defaultMode, timeout, false)
        CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), timer, .defaultMode)
        CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), observer, .defaultMode)
        
        XCTAssertTrue(isSuccess, message, file: (file), line: line)
    }
    
    public func waitForCondition(timeout: Double = 10, message: String = "", file: StaticString = #file, line: UInt = #line, condition: @escaping () -> Bool) {
        wait(condition: condition, timeout: timeout, message: message, file: file, line: line)
    }
}
