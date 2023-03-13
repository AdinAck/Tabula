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
        
        Divider()
        
        // symbol functions
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
        
        Divider()
        
        Button {
            canvas.center()
        } label: {
            Image(systemName: "circle.circle")
        }
        .help("Center canvas")
    }
}

//struct HorizontalToolbar_Previews: PreviewProvider {
//    static var previews: some View {
//        HorizontalToolbar()
//    }
//}
