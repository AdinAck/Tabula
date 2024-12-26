//
//  TabulaApp.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/8/23.
//

import SwiftUI

@main
struct TabulaApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: TabulaDocument()) { file in
            ContentView(document: file.$document)
        }
        
        Window("Schematic Editor", id: "sch") {
            SchematicEditor()
        }
        
        Window("Symbol Editor", id: "sym") {
            SymbolEditor()
        }
    }
}
