//
//  SchPrimaryToolbar.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/10/23.
//

import SwiftUI

struct SchPrimaryToolbar: View {
    private static let tools: [[(() -> Void, String)]] = [
        [({ }, "gear"), ({ }, "gear"), ({ }, "gear")],
        [({ }, "gear"), ({ }, "gear")],
        [({ }, "gear")]
    ]
    
    
    var body: some View {
        // document functions
        Button {
            // nothing
        } label: {
            Image(systemName: "doc.badge.gearshape")
        }
        .help("Document Settings")
        
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
    }
}

//struct HorizontalToolbar_Previews: PreviewProvider {
//    static var previews: some View {
//        HorizontalToolbar()
//    }
//}
