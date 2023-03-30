//
//  Utils.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/12/23.
//

import Foundation
import SwiftUI

extension CGPoint: AdditiveArithmetic {
    public func scale(by factor: Double) -> Self {
        CGPoint(x: x * factor, y: y * factor)
    }
    
    public var magnitudeSquared: Double {
        pow(self.x, 2) + pow(self.y, 2)
    }
    
    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    public func snap(to grid: CGFloat) -> CGPoint {
        CGPoint(x: (self.x / grid).rounded() * grid, y: (self.y / grid).rounded() * grid)
    }
    
    public func toWorld(origin: CGPoint, scale: CGFloat) -> Self {
        return CGPoint(x: origin.x + self.x * scale, y: origin.y + self.y * scale)
    }
    
    func toLocal(_ world: World) -> Self {
        return CGPoint(x: (self.x - world.origin.x) / world.scale, y: (self.y - world.origin.y) / world.scale)
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
    
    public func scale(by factor: Double) -> Self {
        CGSize(width: width * factor, height: height * factor)
    }
}

extension CGRect {
    public static func + (lhs: Self, rhs: CGPoint) -> Self {
        CGRect(origin: lhs.origin + rhs, size: lhs.size)
    }
    
    func toLocal(_ world: World) -> Self {
        CGRect(origin: origin.toLocal(world), size: size.scale(by: 1 / world.scale))
    }
}
