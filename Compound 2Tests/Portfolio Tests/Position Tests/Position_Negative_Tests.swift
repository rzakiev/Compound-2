//
//  Position_Negative_Tests.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 25.04.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation
import XCTest
@testable import Compound_2

class PositionNegativeTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_Positions_UnableToAddLotWithNegativeQuantity() {
        //Given
        var position = Position(companyName: "Сбербанк", lots: [.init(numberOfShares: 10, openingPrice: 20),
                                                                        .init(numberOfShares: 10, openingPrice: 30),
                                                                        .init(numberOfShares: 20, openingPrice: 50),
                                                                        .init(numberOfShares: 15, openingPrice: 34)])
        //When
        let lotCountBeforeAdding = position.lots.count
        position.addNewLot(numberOfShares: -10, openingPrice: 20)
        
        //Then
        XCTAssertEqual(position.lots.count, lotCountBeforeAdding)
    }
    
    func test_Positions_UnableToAddLotWithZeroQuantity() {
        //Given
        var position = Position(companyName: "Сбербанк", lots: [.init(numberOfShares: 10, openingPrice: 20),
                                                                        .init(numberOfShares: 10, openingPrice: 30),
                                                                        .init(numberOfShares: 20, openingPrice: 50),
                                                                        .init(numberOfShares: 15, openingPrice: 34)])
        //When
        let lotCountBeforeAdding = position.lots.count
        position.addNewLot(numberOfShares: 0, openingPrice: 20)
        
        //Then
        XCTAssertEqual(position.lots.count, lotCountBeforeAdding)
    }
    
    func test_Positions_UnableToAddLotWithNegativePrice() {
        //Given
        var position = Position(companyName: "Сбербанк", lots: [.init(numberOfShares: 10, openingPrice: 20),
                                                                        .init(numberOfShares: 10, openingPrice: 30),
                                                                        .init(numberOfShares: 20, openingPrice: 50),
                                                                        .init(numberOfShares: 15, openingPrice: 34)])
        //When
        let lotCountBeforeAdding = position.lots.count
        position.addNewLot(numberOfShares: 20, openingPrice: -20.12)
        
        //Then
        XCTAssertEqual(position.lots.count, lotCountBeforeAdding)
    }
    
    func test_Positions_UnableToAddLotWithZeroPrice() {
        //Given
        var position = Position(companyName: "Сбербанк", lots: [.init(numberOfShares: 10, openingPrice: 20),
                                                                        .init(numberOfShares: 10, openingPrice: 30),
                                                                        .init(numberOfShares: 20, openingPrice: 50),
                                                                        .init(numberOfShares: 15, openingPrice: 34)])
        //When
        let lotCountBeforeAdding = position.lots.count
        position.addNewLot(numberOfShares: 10, openingPrice: 0)
        
        //Then
        XCTAssertEqual(position.lots.count, lotCountBeforeAdding)
    }
}
