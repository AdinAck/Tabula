//
//  CanvasItem.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/9/23.
//

import SwiftUI

struct CanvasItem: Shape {
    typealias Lines = [[CGPoint]]
    
    var origin: CGPoint
    var position: CGPoint
    
    let lines: Lines
    
    let scale: CGFloat = 1
    
    var animatableData: AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData> {
        get { AnimatablePair(CGPoint.AnimatableData(origin.x, origin.y), CGPoint.AnimatableData(position.x, position.y)) }
        set { ((origin.x, origin.y), (position.x, position.y)) = ((newValue.first.first, newValue.first.second), (newValue.second.first, newValue.second.second)) }
    }
    
    func toWorld(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: origin.x + position.x + point.x, y: origin.y + position.y + point.y)
    }
    
    func path(in rect: CGRect) -> Path {
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
