//
//  Symbol.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/9/23.
//

import Foundation
import SwiftUI

class Symbol: ObservableObject {
    typealias Lines = [[CGPoint]]
    
    @Published var position: CGPoint = CGPoint(x: 0, y: 0)
    
    let lines: Lines = [[
        CGPoint(x: -2, y: -2),
        CGPoint(x: 2, y: -2),
        CGPoint(x: 2, y: 2),
        CGPoint(x: -2, y: 2),
        CGPoint(x: -2, y: -2)
    ]]
    
    func view(origin: CGPoint, gridSize: CGFloat, scale: CGFloat) -> some View {
        _SymbolWrapper(origin: origin, scale: scale * gridSize)
            .environmentObject(self)
    }
}

struct SymbolView: CanvasItem {
    var origin: CGPoint
    var position: CGPoint
    var scale: CGFloat
    
    var lines: Lines
    
    var body: some View {
        Path { path in
            for line in lines {
                path.move(to: toWorld(line[0]))
                path.addLines(line.map({ point in
                    toWorld(point)
                }))
            }
        }
    }
}

// this is needed literally because of a SwiftUI bug
struct _SymbolWrapper: View {
    @EnvironmentObject var model: Symbol
    
    let origin: CGPoint
    let scale: CGFloat
    
    var body: some View {
        SymbolView(origin: origin, position: model.position, scale: scale, lines: model.lines)
    }
}
