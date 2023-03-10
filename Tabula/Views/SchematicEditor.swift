//
//  SchematicEditor.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/10/23.
//

import SwiftUI

struct SchematicEditor: View {
    @State var components: [Component] = []
    
    private static let tools: [[(() -> Void, String)]] = [
        [({ }, "gear")]
    ]
    
    var body: some View {
        NavigationView {
            List {
                Text("Test")
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button {
                        // nothing
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }

                }
            }
            
            Canvas(items: components)
            
            VerticalToolbar(tools: SchematicEditor.tools)
        }
    }
}

struct SchematicEditor_Previews: PreviewProvider {
    static var previews: some View {
        SchematicEditor()
    }
}
