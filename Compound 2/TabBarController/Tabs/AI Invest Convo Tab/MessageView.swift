//
//  MessageView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 06.04.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct MessageCell: View {
    
    let messageText: String
    let isResponse: Bool
    
    var body: some View {
        HStack {
            if isResponse {
                MessageView(messageText: messageText, isResponse: isResponse)
                Spacer()
            } else {
                Spacer()
                MessageView(messageText: messageText, isResponse: isResponse)
            }
        }
    }
    
    init(text: String, isResponse: Bool) {
        self.messageText = text
        self.isResponse = isResponse
    }
}

enum MessageType {
    case text
    case companyList
    case buySell
}

struct MessageView: View {
    
    let messageText: String
    let isResponse: Bool
    let messageType: MessageType
    
    init(messageText: String, isResponse: Bool, messageType: MessageType = .text) {
        self.messageText = messageText
        self.isResponse = isResponse
        self.messageType = messageType
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .foregroundColor(isResponse ? Color.blue : .green)
            .frame(minWidth: 200, maxWidth: 300, minHeight: 50, maxHeight: nil)
            .overlay(Text(messageText).font(.system(size: 16, weight: .regular, design: .monospaced)))
    }
    
//    func contentOverlay() -> some View {
//        switch messageText {
//        case "buysellBlock":
//            VStack {
//                Picker(selection: $selectedSegment, label: Text("")) {
//                    ForEach(segments.indices, id:\.self) { index in
//                        Text( self.segments[index].rawValue).tag(index)
//                            .position()
//                    }
//                }.pickerStyle(SegmentedPickerStyle())
//            }
//        default:
//
//        }
//    }
}

//struct MessageModifier: ViewModifier {
//
//    let isReponse: Bool
//
//    func body(content: Content) -> some View {
//        return content.overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
//            .foregroundColor(isReponse ? Color.blue : .green)
//            .frame(width: 200, height: 50))
//    }
//}

struct MessageView_Previews: PreviewProvider {
    @State static var text = "wer"
    static var previews: some View {
        MessageCell(text: text, isResponse: true)
    }
}
