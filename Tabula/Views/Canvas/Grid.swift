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
    
    
    var animatableData: AnimatablePair<CGPoint.AnimatableData, CGFloat> {
        get { AnimatablePair(CGPoint.AnimatableData(origin.x, origin.y), scale) }
        set { ((origin.x, origin.y), scale) = ((newValue.first.first, newValue.first.second), newValue.second) }
    }
    
    private func fade(level: CGFloat, center: CGFloat, transition: CGFloat) -> CGFloat {
        (1 - (level - center)) / transition
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let subdivisions: CGFloat = 5
            let factor = pow(subdivisions, floor(log10(scale) / log10(subdivisions)))
            let size = (scale / factor - 1) / (subdivisions - 1)
            var scaledGap = gridSize * scale / factor
            
            //                let dotSize = dotSize * fade(level: level, center: 5, transition: transition)
            for i in -1...Int(width) / Int(scaledGap) {
                for j in -1...Int(height) / Int(scaledGap) {
                    path.addEllipse(in: CGRect(
                        x: origin.x.truncatingRemainder(dividingBy: scaledGap) + CGFloat(i) * scaledGap - dotSize / CGFloat(2),
                        y: origin.y.truncatingRemainder(dividingBy: scaledGap) + CGFloat(j) * scaledGap - dotSize / CGFloat(2),
                        width: dotSize * size,
                        height: dotSize * size)
                    )
                }
            }
            
            scaledGap = gridSize * scale / pow(subdivisions, floor(log10(scale) / log10(subdivisions)) - 1)
            
            for i in -1...Int(width) / Int(scaledGap) {
                for j in -1...Int(height) / Int(scaledGap) {
                    path.addEllipse(in: CGRect(
                        x: origin.x.truncatingRemainder(dividingBy: scaledGap) + CGFloat(i) * scaledGap - dotSize / CGFloat(2),
                        y: origin.y.truncatingRemainder(dividingBy: scaledGap) + CGFloat(j) * scaledGap - dotSize / CGFloat(2),
                        width: dotSize,
                        height: dotSize)
                    )
                }
            }
            
            path.addEllipse(in: CGRect(x: origin.x - 4, y: origin.y - 4, width: 8, height: 8))
        }
    }
}
