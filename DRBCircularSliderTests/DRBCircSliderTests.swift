//
//  DRBCircSliderTests.swift
//  DRBCircSliderTests
//
//  Created by Dave Barfoot on 13/06/2019.
//  Copyright © 2019 Dave Barfoot. All rights reserved.
//

import XCTest
import SwiftUI
import Combine

@testable import DRBCircularSlider

class DRBCircSliderTests: XCTestCase {
    @ObjectBinding var data: DRBCircularSliderData = DRBCircularSliderData()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_DRBCircularSliderData_check_defaults() {
        // Check the values that are not calculated first
        
        // Calculated defaults are set to values other than that actually specified so check after absolute values
        XCTAssert(data.center.x == data.size/2.0, "x is \(data.center.x). It should be \(data.size/2.0)")
        XCTAssert(data.radius == (data.size/2.0)-data.stroke-2.0, "y is \(data.center.y). It should be \((data.size/2.0)-data.stroke-2.0)")
        XCTAssert(data.handleAngle == Angle(degrees: data.initial - 180.0) , "handleAngle is \(data.handleAngle). It should be \(Angle(degrees: data.initial - 180.0))")
        XCTAssert(data.handlePos.x == data.center.x, "handlePos.x is \(data.handlePos.x). It should be \(data.center.x)")
        XCTAssert(data.handlePos.y == data.center.y-data.radius, "handlePos.y is \(data.handlePos.y). It should be \(data.center.y-data.radius)")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
