//
//  GoogleBookAPITestsNetworking.swift
//  GoogleBookAPITestsNetworking
//
//  Created by Victor Zhong on 10/10/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import XCTest
@testable import GoogleBookAPI

class GoogleBookAPITestsNetworking: XCTestCase {
    var sessionUnderTest: URLSession!

    override func setUp() {
        super.setUp()
        sessionUnderTest = .shared
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }

    // Asynchronous test: faster fail
    func testCallToGoogleBookAPICompletes() {
        // given
        let searchTerm = "banana"
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(searchTerm)")
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?

        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)

        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

}
