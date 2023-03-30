//
//  CanvasItem.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/9/23.
//

import SwiftUI

typealias Lines = [[CGPoint]]

protocol CanvasItemModel: ObservableObject {
    var position: CGPoint { get set }
    var lines: Lines { get }
    var boundingBox: CGRect { get set }
}

extension CanvasItemModel {
    func getBoundingBox() -> CGRect {
        let minX = lines.flatMap { line in
            line.map { point in
                point.x
            }
        }.min()!
        
        let minY = lines.flatMap { line in
            line.map { point in
                point.y
            }
        }.min()!
        
        let maxX = lines.flatMap { line in
            line.map { point in
                point.x
            }
        }.max()!
        
        let maxY = lines.flatMap { line in
            line.map { point in
                point.y
            }
        }.max()!
        
        return CGRect(origin: CGPoint(x: minX, y: minY), size: CGSize(width: maxX - minX, height: maxY - minY))
    }
}

protocol CanvasItemView: View, Animatable {
    var origin: CGPoint { get set }
    var position: CGPoint { get set }
    var scale: CGFloat { get set }
    
    var lines: Lines { get }
}

extension CanvasItemView {
    var animatableData: AnimatablePair<AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData>, CGFloat> {
        get { AnimatablePair(AnimatablePair(CGPoint.AnimatableData(origin.x, origin.y), CGPoint.AnimatableData(position.x, position.y)), scale) }
        set { (((origin.x, origin.y), (position.x, position.y)), scale) = (((newValue.first.first.first, newValue.first.first.second), (newValue.first.second.first, newValue.first.second.second)), newValue.second) }
    }
}
