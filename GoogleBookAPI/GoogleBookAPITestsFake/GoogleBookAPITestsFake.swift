//
//  GoogleBookAPITestsFake.swift
//  GoogleBookAPITestsFake
//
//  Created by Victor Zhong on 10/10/17.
//  Copyright © 2017 Victor Zhong. All rights reserved.
//

import XCTest
@testable import GoogleBookAPI

class GoogleBookAPITestsFake: XCTestCase {
    var apiRequestManagerUnderTest: APIRequestManager!
    var bookTableViewControllerUnderTest: BookTableViewController!
//    var book: Book!

    override func setUp() {
        super.setUp()
        apiRequestManagerUnderTest = APIRequestManager()
        bookTableViewControllerUnderTest = BookTableViewController()

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "volumes", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)

        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=banana")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)

        let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
        apiRequestManagerUnderTest.defaultSession = sessionMock
    }
    
    override func tearDown() {
        apiRequestManagerUnderTest = nil
        bookTableViewControllerUnderTest = nil

        super.tearDown()
    }

    // Fake URLSession with DHURLSession protocol and stubs
    func test_UpdateSearchResults_ParsesData() {
        // given
        let promise = expectation(description: "Status code: 200")

        // when
        XCTAssertEqual(bookTableViewControllerUnderTest.books.count, 0, "searchResults should be empty before the data task runs")
        apiRequestManagerUnderTest.getData(endPoint: "whatever") { data in
            if data != nil {
                if let returnedBooks = Book.getBooks(from: data!) {
                    print("We've got Books! \(returnedBooks.count)")
                    self.bookTableViewControllerUnderTest.books = returnedBooks
                }
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // then
        XCTAssertEqual(bookTableViewControllerUnderTest.books.count, 3, "Didn't parse 3 items from fake response")
    }

    
}
