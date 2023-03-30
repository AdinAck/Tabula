//
//  Symbol.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/9/23.
//

import Foundation
import SwiftUI

class Symbol: CanvasItemModel {
    @Published var position: CGPoint = CGPoint(x: 0, y: 0)
    
    var boundingBox: CGRect = .zero
    
    init() {
        boundingBox = getBoundingBox()
    }
    
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

struct SymbolView: CanvasItemView {
    var origin: CGPoint
    var position: CGPoint
    var scale: CGFloat
    
    var lines: Lines
    
    var body: some View {
        Path { path in
            for line in lines {
                path.move(to: (position + line[0]).toWorld(origin: origin, scale: scale))
                path.addLines(line.map({ point in
                    (position + point).toWorld(origin: origin, scale: scale)
                }))
            }
        }
        .fill(.yellow)
        .saturation(0.2)
    }
}

/*
 LESSON
 ------
 
 changes to published states in observable objects
 do not propegate within the object itself,
 only to views that register it as an
 observed object
 
 because of this i have to make this wrapper
 view that passses the appropriate animated
 states into the raw symbolview in order
 for animations to work
 */

struct _SymbolWrapper: View {
    @EnvironmentObject var model: Symbol
    
    let origin: CGPoint
    let scale: CGFloat
    
    var body: some View {
        SymbolView(origin: origin, position: model.position, scale: scale, lines: model.lines)
    }
}
