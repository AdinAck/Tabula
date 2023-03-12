//
//  SchematicEditor.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/10/23.
//

import SwiftUI

struct SchematicEditor: View {
    @State var document: String? = nil
    
    @State var components: [Component] = []
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
    var body: some View {
        NavigationView {
            List(selection: $document) {
                Section("Project Files") {
                    Text("tmp")
                        .tag("tmp")
                }
            }
            
            ZStack {
                Canvas(items: components)
                
                HStack {
                    Spacer()
                        .layoutPriority(1)
                    
                    SchSecondaryToolbar()
                        .background(.background)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigation) {
                HStack {
                    Button {
                        toggleSidebar()
                    } label: {
                        Image(systemName: "sidebar.leading")
                    }
                    
                    Divider()
                    
                    SchPrimaryToolbar()
                }
            }
        }
        .navigationTitle("")
    }
}

struct SchematicEditor_Previews: PreviewProvider {
    static var previews: some View {
        SchematicEditor()
    }
}
