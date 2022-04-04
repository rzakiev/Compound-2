////
////  InvestmentIdea+DB.swift
////  Compound 2
////
////  Created by Robert Zakiev on 02.04.2022.
////  Copyright © 2022 Robert Zakiev. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//
////MARK: Core Data – InvestmentIdeas
//extension InvestmentIdeas {
//    
//    ///Saves the instance of investment ideas to the database
//    func saveToDB() {
//        let updatedIdeas = StockTargetAuthor_(context: CoreDataManager.shared.context)
//        
//        updatedIdeas.authorName = self.author
//        
//        let coreDataTargets = NSSet()
//        self.values.forEach { idea in
//            let coreDataTarget = idea.asCoreDataEntity()
//            coreDataTargets.adding(coreDataTarget)
//        }
//        updatedIdeas.ideas = coreDataTargets
//        
//        do {
//            try CoreDataManager.shared.context.save()
//        } catch (let error ) {
//            print("Unable to save investment ideas using the shared DB context. Error: \(error)")
//        }
//    }
//    
//    static func fetchFromDB() -> [InvestmentIdeas] {
//        let request = NSFetchRequest<StockTargetAuthor_>(entityName: String(describing: StockTargetAuthor_.self))
//        request.sortDescriptors = [NSSortDescriptor(key: "authorName", ascending: false)]
//        if let stockTargets = try? CoreDataManager.shared.context.fetch(request), stockTargets.isNotEmpty {
//            return stockTargets.map({ InvestmentIdeas(from: $0) })
//        } else {
//            Logger.log(error: "No stock target authors in the DB")
//            return []
//        }
//    }
//    
//    init(from coreDataEntity: StockTargetAuthor_) {
//        self.author = coreDataEntity.authorName ?? "Missing author from DB"
//        self.values = coreDataEntity.ideas == nil ? [] : (coreDataEntity.ideas!.allObjects as! [StockTarget_]).map({ InvestmentIdea(from: $0) })
//    }
//    
//    func asCoreDataEntity() -> StockTargetAuthor_ {
//        let coreDataStockTargetAuthor = StockTargetAuthor_(context: CoreDataManager.shared.context)
//        coreDataStockTargetAuthor.authorName = self.author
//        coreDataStockTargetAuthor.ideas = NSSet(array: [self.values.map({ $0.asCoreDataEntity() })])
//        return coreDataStockTargetAuthor
//    }
//}
//
////MARK: Core Data – InvestmentIdea
//extension InvestmentIdea {
//    
//    func saveToDB() {
//        let _ = self.asCoreDataEntity()
//        
//        do {
//            try CoreDataManager.shared.context.save()
//        } catch (let error ) {
//            print("Unable to save an investment idea using the shared DB context. Idea: \(self). Error: \(error)")
//        }
//    }
//    
//    func asCoreDataEntity() -> StockTarget_ {
//        let coreDataStockTarget = StockTarget_(context: CoreDataManager.shared.context)
//        coreDataStockTarget.priceOnOpening = self.priceOnOpening == nil ? nil : NSNumber(value: self.priceOnOpening!)
//        coreDataStockTarget.targetPrice = self.targetPrice
//        coreDataStockTarget.companyName = self.companyName
//        coreDataStockTarget.currency = self.currency.rawValue
//        coreDataStockTarget.investmentThesis = self.investmentThesis
//        coreDataStockTarget.risk = self.risk
//        coreDataStockTarget.ticker = self.ticker
//        coreDataStockTarget.openingDate = self.openingDate
//        
//        let requestForAuthor = NSFetchRequest<StockTargetAuthor_>(entityName: String(describing: StockTargetAuthor_.self))
//        requestForAuthor.predicate = NSPredicate(format: "authorName = %@", self.authorName)
//        guard let author = try? CoreDataManager.shared.context.fetch(requestForAuthor).first else {
//            Logger.log(error: "Unable to find the stock target's author: \(self.authorName)")
//            return StockTarget_(context: CoreDataManager.shared.context)
//        }
//        
//        coreDataStockTarget.author = author
//        
//        return coreDataStockTarget
//    }
//    
//    init(from coreDataEntity: StockTarget_) {
//        self.ticker = coreDataEntity.ticker ?? "Missing ticker from DB"
//        self.currency = coreDataEntity.currency == nil ? Currency.undefined : Currency(fromString: coreDataEntity.currency!)
//        self.targetPrice = coreDataEntity.targetPrice
//        self.priceOnOpening = coreDataEntity.priceOnOpening == nil ? nil : Double(truncating: coreDataEntity.priceOnOpening!)
//        self.openingDate = coreDataEntity.openingDate
//        self.risk = coreDataEntity.risk ?? "medium"
//        self.companyName = coreDataEntity.companyName ?? "No company name from DB"
//        self.investmentThesis = coreDataEntity.investmentThesis
//        self.authorName = coreDataEntity.author?.authorName ?? "Missing target author in DB"
//    }
//}
