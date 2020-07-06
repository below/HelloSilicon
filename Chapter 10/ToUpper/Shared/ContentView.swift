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
            TextField("Enter some text here", text: $text).padding(20)
            Button(action: {
                text = text.uppercased()
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
