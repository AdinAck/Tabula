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
    
    @State private var subs = Set<AnyCancellable>() // Cancel onDisappear
    
    @State var scale: CGFloat = 1
    @State private var startx: CGFloat = 0
    @State private var starty: CGFloat = 0
    @State var x: CGFloat = 0
    @State var y: CGFloat = 0
    
    private func setScale(delta: CGFloat) {
        let lower: CGFloat = 0.1
        let upper: CGFloat = 2
        
        scale = min(max(scale + delta, lower), upper)
    }
    
    private func clampPos() {
        let lower: CGFloat = -1000
        let upper: CGFloat = 1000
        
        x = min(max(x, lower), upper)
        y = min(max(y, lower), upper)
    }
    
    func trackScrollWheel() {
        NSApp.publisher(for: \.currentEvent)
            .filter { event in event?.type == .scrollWheel }
        //            .throttle(for: .milliseconds(10),
        //                      scheduler: DispatchQueue.main,
        //                      latest: true)
            .sink { event in
                //                vm?.goBackOrForwardBy(delta: Int(event?.deltaY ?? 0))
                if let y = event?.deltaY {
                    setScale(delta: -y/100)
                }
            }
            .store(in: &subs)
    }
    
    var body: some View {
        ZStack {
            Color.black
            Color.white.opacity(0.1)
            
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let center = CGPoint(x: width / 2, y: height / 2)
                let origin = CGPoint(x: x + center.x , y: y + center.y)
                
                let gridSize: CGFloat = 20
                
                Grid(width: width, height: height, origin: origin, gridSize: gridSize, dotSize: 2)
                
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
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    x = startx + gesture.translation.width
                    y = starty + gesture.translation.height
                })
                .onEnded({ gesture in
                    let strength = (gesture.predictedEndTranslation - gesture.translation).magnitude
                    
                    withAnimation(.interpolatingSpring(stiffness: 100, damping: 100, initialVelocity: strength / 30)) {
                        x = startx + gesture.predictedEndTranslation.width
                        y = starty + gesture.predictedEndTranslation.height
                        clampPos()
                    }
                    
                    startx = x
                    starty = y
                })
        )
        .onAppear {
            //            trackScrollWheel()
        }
    }
}
