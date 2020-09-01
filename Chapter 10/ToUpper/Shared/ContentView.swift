//
//  ContentView.swift
//  Shared
//
//  Created by Alexander von Below on 06.07.20.
//

import SwiftUI

class UpperTextModel: ObservableObject {
    @Published var input = ""
    @Published var output = ""
}

struct ContentView: View {
    
    @State var text: String = ""
    
    func toUpper(_ input: String) -> String {
        var output : [CChar] = Array(repeating: 0, count: 255)
        
        let s: String = text
        mytoupper(s, &output)
        
        guard let outputString = String(validatingUTF8: output) else {
            return "Unable to convert \(input)"
        }
        return outputString
    }
    
    var body: some View {
        #if os(macOS)
        let alignment = TextAlignment.leading
        #else
        let alignment = TextAlignment.center
        #endif

        VStack {
            TextField("Enter some text here", text: $text).padding(20)
            Text(toUpper(text))

        }.multilineTextAlignment(alignment).padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
