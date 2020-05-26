//
//  AddNewPositionView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 15.03.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

struct AddNewPositionView: View {
    
    //List of companies for the picker view
    private let companies:[String] = (try? FinancialDataManager.getMumberOfSharesForAllCompanies().map({ $0.key }).sorted()) ?? FinancialDataManager.listOfAllCompanies()
    
    @State var numberOfShares: String = ""
    
    @State var costBasis: String = ""
    
    @State var selectedCompany: String = ""
    
    //Displayed when an investor attempted to enter the number of shares
    @State var displayErrorMessage = false
    @State var errorMessage = ""
    
    @Binding var displayAddPositionView: Bool
    
    let newPositionAdded: (String, Int, Double) -> Void
    
    init(displayAddPositionView: Binding<Bool>, newPositionAdded: @escaping (String, Int, Double) -> Void) {
        _displayAddPositionView = displayAddPositionView
        self.newPositionAdded = newPositionAdded
    }
    
    var body: some View {
        VStack(alignment: .center) {
            addPositionTitle
            
            companySelectionView
            
            numberOfSharesView
            
            costsBasisView
            
            addNewPositionButton
            
            Spacer()
        }.padding(.horizontal, 10)
        .onAppear(perform: { self.selectedCompany = self.companies[0] })
        .alert(isPresented: $displayErrorMessage) { Alert(title: Text("Ошибка!"), message: Text(self.errorMessage), dismissButton: .default(Text("OK"), action: { self.errorMessage = "" })) }
    }
}

//Supporting Views
extension AddNewPositionView {
    var costsBasisView: some View {
        HStack(spacing: 10) {
            
            Text("Средняя цена:")
            Spacer()
            TextField("Цена", text: $costBasis)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 240)
            
            
        }.frame(maxWidth: 400)
    }
    
    var numberOfSharesView: some View {
        HStack(spacing: 10) {
            
            Text("Кол-во акций:")
            Spacer()
            TextField("Целое число", text: $numberOfShares)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 240)
            
        }.frame(maxWidth: 400)
    }
    
    var companySelectionView: some View {
        Picker("Компания", selection:  $selectedCompany) {
            ForEach(companies, id:\.self) { company in
                Text(company).font(.system(size: 20))
            }
        }.frame(width: 50, alignment: .center)
    }
    
    var addPositionTitle: some View {
        HStack {
            Text("Добавить Позицию")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .bold()
                .frame(alignment: .leading)
            
            Spacer()
            Button(action: { self.displayAddPositionView = false }) {
                Text("Отменить")
            }
        }.padding([.top], 20)
    }
    
    var addNewPositionButton: some View {
        Button(action: {
            self.validateTextFields()
        }) {
            RoundedRectangle(cornerRadius: 10)
                .frame(maxWidth: 400, maxHeight: 50, alignment: .center)
                .foregroundColor(Color.green)
                .overlay(Text("Добавить")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            )
        }
    }
}

extension AddNewPositionView {
    func validateTextFields() {
        let shareCountValidationResult = NewPositionDataValidator.numberOfSharesIsValid(for: self.selectedCompany, numberOfShares: self.numberOfShares)
        let costBasisValidationResult = NewPositionDataValidator.costBasisIsValid(for: self.selectedCompany, costBasis: self.costBasis)
        
        if shareCountValidationResult.isValid != true || costBasisValidationResult.isValid != true {
            //Checking for share count errors
            self.errorMessage += shareCountValidationResult.message ?? ""
            self.errorMessage += shareCountValidationResult.message == nil ? "" : "\n"
            
            self.errorMessage += costBasisValidationResult.message ?? ""
            
            self.displayErrorMessage = true
        } else {
            self.displayAddPositionView = false
            self.newPositionAdded(self.selectedCompany,
                                  Int(self.numberOfShares)!,
                                  Double(self.costBasis)!)
        }
    }
}

#if DEBUG
struct AddNewPositionView_Previews: PreviewProvider {
    
    @State static var someVar = true
    
    static var previews: some View {
        ForEach(["iPhone 11", "iPad (7th generation)"], id: \.self) { device in
            AddNewPositionView(displayAddPositionView: $someVar,
                               newPositionAdded: {_,_,_  in })
                .previewDevice(PreviewDevice(rawValue: device))
        }
    }
}
#endif
