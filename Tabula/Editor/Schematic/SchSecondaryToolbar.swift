//
//  SchSecondaryToolbar.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/10/23.
//

import SwiftUI

struct SchSecondaryToolbar: View {
    private static let tools: [[(() -> Void, String)]] = [
        [({ }, "cursorarrow"), ({ }, "line.diagonal")],
        [({ }, "plus"), ({ }, "xmark"), ({ }, "arrowtriangle.down.square")],
        [({ }, "textformat")]
    ]
    
    var body: some View {
        ScrollView {
            ForEach(0..<Self.tools.count, id: \.self) { s in
                ForEach(0..<Self.tools[s].count, id: \.self) { i in
                    Button {
                        Self.tools[s][i].0()
                    } label: {
                        Image(systemName: Self.tools[s][i].1)
                    }
                    .buttonStyle(.borderless)
                    .frame(width: 30, height: 30)
                    .background( RoundedRectangle(cornerRadius: 8).fill(.black.opacity(0.2)) )
                    .padding(.horizontal, 8)
                    
                }
                
                Divider()
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

//struct VerticalToolbar_Previews: PreviewProvider {
//    static var previews: some View {
//        VerticalToolbar()
//    }
//}
