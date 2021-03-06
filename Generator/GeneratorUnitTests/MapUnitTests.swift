//
//  MapUnitTests.swift
//  Generator
//
//  Created by Yunus Eren Guzel on 21/09/16.
//  Copyright © 2016 yeg. All rights reserved.
//

import XCTest

class MapUnitTests: XCTestCase {

    func testMapMustInitWithSize() {
        let size = 5
        let map = Map(size: size)
        XCTAssertNotNil(map)
        XCTAssertEqual(map.size, size)
    }
    
    func testMapMustHaveNumberOfCellsEqualToSquareOfSize() {
        let map = Map(size: 10)
        XCTAssertEqual(map.cells.count, map.size * map.size)
    }
    
    

}
