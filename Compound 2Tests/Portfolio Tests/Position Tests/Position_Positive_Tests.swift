//
//  PositionTests.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 30.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import XCTest
@testable import Compound_2

class PositionPositiveTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_Positions_AverageOpeningPriceIsProperlyCalculated() {
        //Given
        let position = Position(companyName: "Сбербанк", lots: [.init(numberOfShares: 10, openingPrice: 20),
                                                                        .init(numberOfShares: 10, openingPrice: 30),
                                                                        .init(numberOfShares: 20, openingPrice: 50),
                                                                        .init(numberOfShares: 15, openingPrice: 34)])
        
        //Then
        XCTAssertEqual(position.averageOpeningPrice, 36.54, accuracy: 0.01, "Position's average opening price was expected to be 36.54, but turned out to be \(position.averageOpeningPrice)")
    }
    
    func test_Positions_AverageOpeningPriceIsCalcualtedProperlyAfterAddingNewPosition() {
        //Given
        var position = Position(companyName: "Сбербанк", lots: [.init(numberOfShares: 10, openingPrice: 20),
                                                                        .init(numberOfShares: 10, openingPrice: 30),
                                                                        .init(numberOfShares: 20, openingPrice: 50),
                                                                        .init(numberOfShares: 15, openingPrice: 34)])
        //When
        position.addNewLot(numberOfShares: 100, openingPrice: 25)
        
        //Then
        XCTAssertEqual(position.averageOpeningPrice, 29.09, accuracy: 0.01, "Position's average opening price was expected to be 29.09, but turned out to be \(position.averageOpeningPrice)")
    }
    
    func test_Positions_NewLotsCanBeAdded() {
        //Given
        var position = Position(companyName: "Сбербанк", lots: [.init(numberOfShares: 10, openingPrice: 20),
                                                                .init(numberOfShares: 10, openingPrice: 30),
                                                                .init(numberOfShares: 20, openingPrice: 50),
                                                                .init(numberOfShares: 15, openingPrice: 34)])
        let firstCounter = position.lots.count
        
        //When
        position.addNewLot(numberOfShares: 100, openingPrice: 25)
        
        //Then
        XCTAssertNotNil(position.lots.first(where: { $0.numberOfShares == 100 && $0.openingPrice == 25 }))
        XCTAssertEqual(position.lots.count, firstCounter + 1)
    }
    
    func test_Positions_LotsCanBeRemoved() {
        //Given
        var position = Position(companyName: "Сбербанк", lots: [.init(numberOfShares: 10, openingPrice: 20),
                                                                .init(numberOfShares: 10, openingPrice: 30),
                                                                .init(numberOfShares: 20, openingPrice: 50),
                                                                .init(numberOfShares: 15, openingPrice: 34)])
        let firstCounter = position.lots.count
        
        //When
        position.removeLots(at: .init(arrayLiteral: 1,2))
        
        //Then
        XCTAssertEqual(position.lots.count, firstCounter - 2)
    }
    
    
    func test_Positions_AverageOpeningPriceIsCorrect() {
        //Given
       
    }
}
