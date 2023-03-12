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
    var scale: CGFloat
    
    let gridSize: CGFloat
    let dotSize: CGFloat
    let subdivisions: CGFloat = 5
    
    
    var animatableData: AnimatablePair<CGPoint.AnimatableData, CGFloat> {
        get { AnimatablePair(CGPoint.AnimatableData(origin.x, origin.y), scale) }
        set { ((origin.x, origin.y), scale) = ((newValue.first.first, newValue.first.second), newValue.second) }
    }
    
    private func generator(path: inout Path, offset: CGFloat, doScale: Bool) -> Void {
        let factor = pow(subdivisions, floor(log10(scale) / log10(subdivisions)) - offset)
        let size = (scale / factor - 1) / (subdivisions - 1)
        let scaledGap = gridSize * scale / factor
        
        // TODO: render artifacts on edges of grid need to be fixed... what is the cause?
        for i in -1...Int(width) / Int(scaledGap) {
            for j in -1...Int(height) / Int(scaledGap) {
                let size = dotSize * (doScale ? size : 1)
                path.addEllipse(in: CGRect(
                    x: origin.x.truncatingRemainder(dividingBy: scaledGap) + CGFloat(i) * scaledGap - size / CGFloat(2),
                    y: origin.y.truncatingRemainder(dividingBy: scaledGap) + CGFloat(j) * scaledGap - size / CGFloat(2),
                    width: size,
                    height: size)
                )
            }
        }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            generator(path: &path, offset: 0, doScale: true)
            generator(path: &path, offset: 1, doScale: false)
            
            path.addEllipse(in: CGRect(x: origin.x - 4, y: origin.y - 4, width: 8, height: 8))
        }
    }
}
