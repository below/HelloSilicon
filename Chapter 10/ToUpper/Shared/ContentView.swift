//
//  ContentView.swift
//  Shared
//
//  Created by Alexander von Below on 06.07.20.
//

import SwiftUI

struct ContentView: View {
    
    @State var text: String = ""
    var body: some View {
        VStack {
            #if os(macOS)
            let alignment = TextAlignment.leading
            #else
            let alignment = TextAlignment.center
            #endif

            TextField("Enter some text here", text: $text).padding(20).multilineTextAlignment(alignment)
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
