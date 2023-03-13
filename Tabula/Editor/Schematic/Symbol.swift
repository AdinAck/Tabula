//
//  Symbol.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/9/23.
//

import Foundation
import SwiftUI

struct Symbol {
    typealias Lines = [[CGPoint]]
    
    var position: CGPoint = CGPoint(x: 0, y: 0)
    let lines: Lines
    
    func view(origin: CGPoint) -> CanvasItem {
        CanvasItem(origin: origin, position: position, lines: lines)
    }
}

struct _SymbolView: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
        }
    }
}
