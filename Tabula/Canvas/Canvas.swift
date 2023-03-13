//
//  Canvas.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/8/23.
//

import Foundation
import SwiftUI
import Combine

class Canvas: ObservableObject {
    // params
    @Published var items: [Component] = [Component(symbol: Symbol())]
    
    @Published var scale: CGFloat = 1
    @Published var origin: CGPoint = CGPoint.zero
    
    // internal
    @Published fileprivate var mouse: CGPoint = CGPoint.zero
    @Published fileprivate var frame: CGRect = CGRect(origin: CGPoint.zero, size: CGSize.zero)
    
    fileprivate let gridSize: CGFloat = 20
    
    var view: some View {
        CanvasView()
            .environmentObject(self)
    }
    
    func center() {
        withAnimation(.spring(response: 1, dampingFraction: 1)) {
            origin = CGPoint.zero
            scale = 1
        }
    }
    
    fileprivate func magnify(delta: CGFloat) {
        let lower: CGFloat = 1 / 125
        let upper: CGFloat = 5
        
        if (lower...upper).contains(scale * (1 + delta)) {
            origin.x -= (mouse.x - origin.x) * delta
            origin.y -= (mouse.y - origin.y) * delta
            scale *= 1 + delta
            
            clampPos()
        }
    }
    
    fileprivate func clampPos() {
        let lower: CGFloat = -625 * gridSize * scale
        let upper: CGFloat = 625 * gridSize * scale
        
        origin.x = min(max(origin.x, lower), upper)
        origin.y = min(max(origin.y, lower), upper)
    }
}

struct CanvasView: View {
    @EnvironmentObject var model: Canvas
    
    @State private var subs = Set<AnyCancellable>()
    @State private var rawMouse: CGPoint = CGPoint.zero
    
    func trackEvents() {
        NSApp.publisher(for: \.currentEvent)
            .sink { event in
                if let event {
                    switch event.type {
                    case .scrollWheel:
                        withAnimation(.spring(response: 0.2, dampingFraction: 1)) {
                            model.magnify(delta: -event.deltaY/100)
                        }
                    case .rightMouseDragged:
                        model.origin.x += event.deltaX
                        model.origin.y += event.deltaY
                    case .rightMouseUp:
                        withAnimation(.spring()) {
                            model.clampPos()
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
            
            VStack {
                GeometryReader { geometry in
                    let frame = geometry.frame(in: CoordinateSpace.global) // for mouse
                    
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let center = CGPoint(x: width / 2, y: height / 2)
                    let origin = model.origin + center
                    
                    // grid and items
                    Grid(width: width, height: height, origin: origin, scale: model.scale, gridSize: model.gridSize, dotSize: 2)
                        .onChange(of: rawMouse) { newValue in
                            model.mouse = CGPoint(x: rawMouse.x - frame.origin.x, y: height - rawMouse.y + frame.origin.y) - center
                        }
                    
                    ForEach(model.items) { item in
                        item.symbol.view(origin: origin, gridSize: model.gridSize, scale: model.scale)
                            .gesture(
                                DragGesture()
                                    .onChanged({ gesture in
                                        withAnimation(.spring(response: 0.1)) {
                                            item.symbol.position = ((gesture.location - origin).scale(by: 1.0 / (model.gridSize * model.scale))).snap(to: 1)
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
                .layoutPriority(1)
                
                // canvas stats
                HStack {
                    // stats
                    Text("**Scale:** \(String(format: "%.2f", model.scale))")
                    Text("**X:** \(Int((-model.origin.x / (model.gridSize * model.scale)).rounded()))")
                    Text("**Y:** \(Int((-model.origin.y / (model.gridSize * model.scale)).rounded()))")
                    Text("**Mouse X:** \(Int(((model.mouse.x - model.origin.x) / (model.gridSize * model.scale)).rounded()))")
                    Text("**Mouse Y:** \(Int(((model.mouse.y - model.origin.y) / (model.gridSize * model.scale)).rounded()))")
                    
                    Spacer()
                }
                .padding(8)
                .background(.background)
                .animation(.none, value: model.scale)
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
