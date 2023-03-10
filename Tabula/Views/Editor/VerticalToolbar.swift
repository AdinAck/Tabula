//
//  VerticalToolbar.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/10/23.
//

import SwiftUI

struct VerticalToolbar: View {
    let tools: [[(() -> Void, String)]]
    
    var body: some View {
        VStack {
            ForEach(0..<tools.count, id: \.self) { s in
                ForEach(0..<tools[s].count, id: \.self) { i in
                    Button {
                        tools[s][i].0()
                    } label: {
                        Image(systemName: tools[s][i].1)
                            .font(.system(size: 24))
                    }
                    .buttonStyle(.borderless)
                    .padding(8)
                    .background( RoundedRectangle(cornerRadius: 8).fill(.black.opacity(0.2)) )
                    .padding(8)

                }
                
                Divider()
            }
        }
        
        Spacer()
    }
}

//struct VerticalToolbar_Previews: PreviewProvider {
//    static var previews: some View {
//        VerticalToolbar()
//    }
//}
