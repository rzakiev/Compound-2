//
//  ProductionSpeedTests.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 12.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import XCTest
@testable import Compound_2

class ProductionSpeedTests: XCTestCase {
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    func test_Production_InitializationTime() {
        self.measure {
            let _ = ProductionDataManager.getProductionFigures(for: "Газпром")
        }
    }
}
