//
//  Grid.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/8/23.
//

import SwiftUI

struct Grid: Shape {
    let width: CGFloat
    let height: CGFloat
    var origin: CGPoint
    let gridSize: CGFloat
    let dotSize: CGFloat
    
    let scale: CGFloat = 1
    
    var animatableData: CGPoint.AnimatableData {
        get { CGPoint.AnimatableData(origin.x, origin.y) }
        set { (origin.x, origin.y) = (newValue.first, newValue.second) }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            for i in -1...Int(width) / Int(gridSize) + 1 {
                for j in -1...Int(height) / Int(gridSize) + 1 {
                    path.addEllipse(in: CGRect(
                        x: origin.x.truncatingRemainder(dividingBy: gridSize) + CGFloat(i) * gridSize - dotSize / CGFloat(2) * scale,
                        y: origin.y.truncatingRemainder(dividingBy: gridSize) + CGFloat(j) * gridSize - dotSize / CGFloat(2) * scale,
                        width: dotSize * scale,
                        height: dotSize * scale)
                    )
                }
            }
            
            path.addEllipse(in: CGRect(x: origin.x - 4, y: origin.y - 4, width: 8, height: 8))
        }
    }
}
