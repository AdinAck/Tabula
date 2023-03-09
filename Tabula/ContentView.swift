//
//  ContentView.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/8/23.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: TabulaDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(TabulaDocument()))
    }
}
