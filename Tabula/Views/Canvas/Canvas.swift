//
//  Canvas.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/8/23.
//

import SwiftUI
import Combine

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

struct Canvas: View {
    @State var items: [Component]
    
    @State private var subs = Set<AnyCancellable>()
    
    @State var scale: CGFloat = 1
    @State private var startx: CGFloat = 0
    @State private var starty: CGFloat = 0
    @State var origin: CGPoint = CGPoint.zero
    
    @State private var rawMouse: CGPoint = CGPoint.zero
    @State private var mouse: CGPoint = CGPoint.zero
    @State private var frame: CGRect = CGRect(origin: CGPoint.zero, size: CGSize.zero)
    
    private func setScale(delta: CGFloat) {
        let lower: CGFloat = 1
        let upper: CGFloat = 50
        
        if (lower...upper).contains(scale * (1 + delta)) {
            origin.x -= (mouse.x - origin.x) * delta
            origin.y -= (mouse.y - origin.y) * delta
            scale *= 1 + delta
            // scale += delta -> delta / scale
            // scale *= (1 + delta)
            // scale +=
        }
     }
    
    private func clampPos() {
        let lower: CGFloat = -500 * scale
        let upper: CGFloat = 500 * scale
        
        origin.x = min(max(origin.x, lower), upper)
        origin.y = min(max(origin.y, lower), upper)
    }
    
    func trackEvents() {
        NSApp.publisher(for: \.currentEvent)
            .sink { event in
                if let event {
                    switch event.type {
                    case .scrollWheel:
                        withAnimation(.spring(response: 0.2, dampingFraction: 1)) {
                            setScale(delta: -event.deltaY/100)
                        }
                    case .rightMouseDragged:
                        origin.x += event.deltaX
                        origin.y += event.deltaY
                    case .rightMouseUp:
                        withAnimation(.spring()) {
                            clampPos()
                        }
                    case .mouseMoved:
                        rawMouse = event.locationInWindow
                    default:
                        return
                    }
                    
                }
            }
            .store(in: &subs)
    }
    
    var body: some View {
        ZStack {
            Color.black
            Color.white.opacity(0.1)
            
            GeometryReader { geometry in
                let frame = geometry.frame(in: CoordinateSpace.global) // for mouse
                
                let width = geometry.size.width
                let height = geometry.size.height
                let center = CGPoint(x: width / 2, y: height / 2)
                let origin = origin + center
                
                let gridSize: CGFloat = 20
                
                Grid(width: width, height: height, origin: origin, scale: scale, gridSize: gridSize, dotSize: 2)
                    .onChange(of: scale) { newValue in
                        mouse = CGPoint(x: rawMouse.x - frame.origin.x, y: height - rawMouse.y) - center
                    }
                ForEach(items) { item in
                    item.symbol.view(origin: origin)
                        .gesture(
                            DragGesture()
                                .onChanged({ gesture in
                                    withAnimation(.spring(response: 0.1)) {
                                        item.symbol.position = (gesture.location - origin).snap(to: gridSize)
                                    }
                                })
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.2, dampingFraction: 1)) {
                                item.symbol.position = CGPoint(x: 0, y: 0)
                            }
                        }
                }
            }
        }
        .onAppear {
            trackEvents()
        }
        .onDisappear {
            for sub in subs {
                sub.cancel()
            }
        }
        .onHover { hovering in
            if hovering {
                NSCursor.crosshair.push()
            } else {
                NSCursor.pop()
            }
        }
    }
}
