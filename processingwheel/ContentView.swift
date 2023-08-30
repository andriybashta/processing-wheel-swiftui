//
//  ContentView.swift
//  processingwheel
//
//  Created by Bashta on 30.08.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var index = 2
    
    var body: some View {
        VStack {
            SticksPicker(activePageIndex: $index, pages: 10)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
