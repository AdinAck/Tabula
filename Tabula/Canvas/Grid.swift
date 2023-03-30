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
    let subdivisions: CGFloat = 6
    
    
    var animatableData: AnimatablePair<CGPoint.AnimatableData, CGFloat> {
        get { AnimatablePair(CGPoint.AnimatableData(origin.x, origin.y), scale) }
        set { ((origin.x, origin.y), scale) = ((newValue.first.first, newValue.first.second), newValue.second) }
    }
    
    private func clampScale(scale: CGFloat) -> CGFloat {
        return max(scale, 1e-4)
    }
    
    private func generator(path: inout Path, offset: CGFloat, doScale: Bool) -> Void {
        let scale = clampScale(scale: scale)
        let factor = pow(subdivisions, floor(log10(scale) / log10(subdivisions)) - offset)
        let size = (scale / factor - 1) / (subdivisions - 1)
        let scaledGap = gridSize * scale / factor
        
        let dotSize = dotSize * (doScale ? size : 1)
        
//        var rects: [CGRect] = []
        
        // ranges are extended by 2 because of a subtle float precision error i think
        for i in -2...Int(width) / Int(scaledGap) + 1 {
            for j in -2...Int(height) / Int(scaledGap) + 1 {
                let rect = CGRect(
                    x: origin.x.truncatingRemainder(dividingBy: scaledGap) + CGFloat(i) * scaledGap - dotSize / CGFloat(2),
                    y: origin.y.truncatingRemainder(dividingBy: scaledGap) + CGFloat(j) * scaledGap - dotSize / CGFloat(2),
                    width: dotSize,
                    height: dotSize
                )
                
                path.addRect(rect)
            }
        }
        
//        path.addRects(rects)
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            DispatchQueue.global().sync {
                generator(path: &path, offset: 0, doScale: true)
                generator(path: &path, offset: 1, doScale: false)
            }
            
            path.addEllipse(in: CGRect(x: origin.x - 4, y: origin.y - 4, width: 8, height: 8))
        }
    }
}
