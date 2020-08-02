//
//  ContentView.swift
//  Shared
//
//  Created by Alexander von Below on 06.07.20.
//

import SwiftUI

extension View {
    public func myAlignment() -> some View {
        let alignment: TextAlignment
        #if os(macOS)
        alignment = .leading
        #else
        alignment = .center
        #endif
        return self.multilineTextAlignment(alignment)
    }
}

struct ContentView: View {
    
    @State var text: String = ""
    var body: some View {
        VStack {
            TextField("Enter some text here", text: $text).padding(20).myAlignment()
            Button(action: {
                var output : [CChar] = Array(repeating: 0, count: 255)
                
                let s: String = text
                mytoupper(s, &output)
                
                guard let outputString = String(validatingUTF8: output) else {
                    return
                }
                text = outputString
            }) {
                Text("To Upper")
            }

        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
