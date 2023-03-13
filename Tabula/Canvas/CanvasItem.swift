//
//  CanvasItem.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/9/23.
//

import SwiftUI

protocol CanvasItem: View, Animatable {
    typealias Lines = [[CGPoint]]

    var origin: CGPoint { get set }
    var position: CGPoint { get set }
    var scale: CGFloat { get set }

    var lines: Lines { get }
}

extension CanvasItem {
    var animatableData: AnimatablePair<AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData>, CGFloat> {
        get { AnimatablePair(AnimatablePair(CGPoint.AnimatableData(origin.x, origin.y), CGPoint.AnimatableData(position.x, position.y)), scale) }
        set { (((origin.x, origin.y), (position.x, position.y)), scale) = (((newValue.first.first.first, newValue.first.first.second), (newValue.first.second.first, newValue.first.second.second)), newValue.second) }
    }
    
    func toWorld(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: origin.x + (position.x + point.x) * scale, y: origin.y + (position.y + point.y) * scale)
    }
}
