//
//  Utils.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/12/23.
//

import Foundation

extension CGPoint: AdditiveArithmetic {
    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    public func snap(to grid: CGFloat) -> CGPoint {
        CGPoint(x: (self.x / grid).rounded() * grid, y: (self.y / grid).rounded() * grid)
    }
}

extension CGSize: AdditiveArithmetic {
    public static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    
    public static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
    
    public var magnitude: CGFloat {
        sqrt(pow(width, 2) + pow(height, 2))
    }
}
