//
//  UrlGalleryTests.swift
//  UrlGalleryTests
//
//  Created by Agasthyam on 24/03/20.
//  Copyright © 2020 Agasthyam. All rights reserved.
//

import XCTest
@testable import UrlGallery

class UrlGalleryTests: XCTestCase {
    
    var test:PhotosViewController!
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    test = PhotosViewController()
    
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        test = nil
    }

    func testUrlNetworking() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertNoThrow(try test.getPhotData(urlString: "https://picsum.photos/list"))
    }

    func testPerformanceUrlNetworking() {
        // This is an example of a performance test case.
        self.measure {
            test.getPhotData(urlString: "https://picsum.photos/list")
        }
    }

}
