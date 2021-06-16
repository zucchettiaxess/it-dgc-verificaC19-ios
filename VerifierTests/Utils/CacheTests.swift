//
//  UtilsTests.swift
//  VerificaC19
//
//

import XCTest
@testable import VerificaC19

class CacheTests: XCTestCase {
    var cache = Cache<AnyObject, Int>()
    
    override func setUpWithError() throws {
        cache[self] = 1
    }

    override func tearDownWithError() throws {
    }
    
    func testCacheCount() {
        XCTAssertEqual(cache.count, 1)
    }
    
    func testCacheValues() {
        XCTAssertEqual(cache[self], 1)
        
        cache[self] = 1
        XCTAssertEqual(cache[self], 1)
        XCTAssertEqual(cache.count, 1)
        
        cache[self] = 2
        XCTAssertEqual(cache[self], 2)
        XCTAssertEqual(cache.count, 1)
        
        cache[self] = nil
        XCTAssertEqual(cache[self], nil)
        XCTAssertEqual(cache.count, 0)
    }
}
