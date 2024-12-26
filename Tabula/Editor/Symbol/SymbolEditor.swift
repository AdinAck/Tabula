//
//  SymbolEditor.swift
//  Tabula
//
//  Created by Adin Ackerman on 4/12/23.
//

import SwiftUI

struct SymbolEditor: View {
    @State var component: Component? = nil
    @StateObject var canvas = Canvas()
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
    var body: some View {
        NavigationView {
            List(selection: $component) {
                Section("Symbols") {
                    Text("tmp")
                        .tag("tmp")
                }
            }
            
            ZStack {
                canvas.view()
                
                HStack {
                    Spacer()
                        .layoutPriority(1)
                    
                    SymSecondaryToolbar()
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
                    
                    SymPrimaryToolbar()
                        .environmentObject(canvas)
                }
            }
        }
        .navigationTitle("")
    }
}

struct SymbolEditor_Previews: PreviewProvider {
    static var previews: some View {
        SymbolEditor()
    }
}
