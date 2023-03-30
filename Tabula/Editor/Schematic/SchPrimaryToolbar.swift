//
//  SchPrimaryToolbar.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/10/23.
//

import SwiftUI

struct SchPrimaryToolbar: View {
    @EnvironmentObject var canvas: Canvas
    
    @State private var tmp: Bool = false
    
    private static let tools: [[(() -> Void, String)]] = [
        [({ }, "gear"), ({ }, "gear"), ({ }, "gear")],
        [({ }, "gear"), ({ }, "gear")],
        [({ }, "gear")]
    ]
    
    
    var body: some View {
        // document functions
        Group {
            Button {
                tmp.toggle()
            } label: {
                Image(systemName: "doc.badge.gearshape")
            }
            .help("Document Settings")
            .sheet(isPresented: $tmp) {
                VStack {
                    Text("Hello, World!")
                        .frame(maxHeight: .infinity)
                    HStack {
                        Spacer()
                        
                        Button("Done") {
                            tmp.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(8)
                    }
                }
                .frame(width: 500, height: 300)
            }
            
            Button {
                // nothing
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            .help("Export")
            
            Button {
                // nothing
            } label: {
                Image(systemName: "text.magnifyingglass")
            }
            .help("Find")
        }
        
        Divider()
        
        // symbol functions
        Group {
            Button {
                // nothing
            } label: {
                Image(systemName: "rotate.right")
            }
            .help("Rotate selected clockwise")
            
            Button {
                // nothing
            } label: {
                Image(systemName: "rotate.left")
            }
            .help("Rotate selected counterclockwise")
            
            Button {
                // nothing
            } label: {
                Image(systemName: "character.textbox")
            }
            .help("Annotate schematic")
            
            Button {
                // nothing
            } label: {
                Image(systemName: "chart.bar.doc.horizontal")
            }
            .help("Generate BOM")
        }
        
        Divider()
        
        Group {
            Button {
                // nothing
            } label: {
                Image(systemName: "plus")
            }
            .help("Add symbol")
        }
        
        Divider()
        
        // misc
        Group {
            Button {
                canvas.center()
            } label: {
                Image(systemName: "circle.circle")
            }
            .help("Center canvas")
            
            Button {
                canvas.selected.removeAll()
            } label: {
                Image(systemName: "xmark.circle")
            }
            .disabled(canvas.selected.count == 0)
            .keyboardShortcut(.cancelAction)
            .help("Clear selection")
        }
    }
}

//struct HorizontalToolbar_Previews: PreviewProvider {
//    static var previews: some View {
//        HorizontalToolbar()
//    }
//}
