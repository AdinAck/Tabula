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
    @Published var items: [Component] = [
        Component(symbol: Symbol()),
        Component(symbol: Symbol()),
        Component(symbol: Symbol()),
        Component(symbol: Symbol()),
        Component(symbol: Symbol()),
        Component(symbol: Symbol()),
        Component(symbol: Symbol()),
        Component(symbol: Symbol()),
        Component(symbol: Symbol()),
        Component(symbol: Symbol()),
    ]
    
    // public
    @Published var scale: CGFloat = 1
    @Published var origin: CGPoint = CGPoint.zero
    
    @Published var selected: Set<Component> = Set()
    @Published fileprivate var tmpSelected: Set<Component> = Set()
    @Published var selectionRect: CGRect = CGRect.zero
    
    // internal
    @Published fileprivate var mouse: CGPoint = CGPoint.zero
    @Published fileprivate var frame: CGRect = CGRect(origin: CGPoint.zero, size: CGSize.zero)
    
    fileprivate let gridSize: CGFloat = 20
    
    func view() -> some View {
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
            .throttle(for: .milliseconds(8),
                      scheduler: DispatchQueue.main,
                      latest: true)
            .sink { event in
                    if let event {
                        switch event.type {
                        case .scrollWheel:
                            withAnimation(.spring(response: 0.2, dampingFraction: 1)) {
                                model.magnify(delta: -event.deltaY/50)
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
    
    func isSelected(_ component: Component) -> Bool {
        return model.selected.contains(component) || model.tmpSelected.contains(component)
    }
    
    var body: some View {
        VStack {
            // canvas
            GeometryReader { geometry in
                let frame = geometry.frame(in: CoordinateSpace.global) // for mouse
                
                let width = geometry.size.width
                let height = geometry.size.height
                let center = CGPoint(x: width / 2, y: height / 2)
                let origin = model.origin + center
                
                let world = World(origin: origin, scale: model.gridSize * model.scale)
                
                // background
                Color.black
                Color.white.opacity(0.1)
                    .onTapGesture {
                        model.selected.removeAll()
                    }
                    .gesture( // TODO: one last thing, shift drage to deselect already selected components
                        DragGesture()
                            .modifiers(.shift)
                            .onChanged({ gesture in
                                model.selectionRect = CGRect(origin: gesture.startLocation, size: gesture.translation)
                                
                                for component in model.items {
                                    let box = component.symbol.boundingBox + component.symbol.position
                                    
                                    if model.selectionRect.toLocal(world).intersects(box) {
                                        model.tmpSelected.insert(component)
                                    } else {
                                        model.tmpSelected.remove(component)
                                    }
                                }
                            })
                            .onEnded({ gesture in
                                model.selectionRect = .zero
                                model.selected = model.selected.union(model.tmpSelected)
                                model.tmpSelected.removeAll()
                            })
                    )
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                model.selectionRect = CGRect(origin: gesture.startLocation, size: gesture.translation)
                                
                                for component in model.items {
                                    let box = component.symbol.boundingBox + component.symbol.position
                                    
                                    if model.selectionRect.toLocal(world).intersects(box) {
                                        model.selected.insert(component)
                                    } else {
                                        model.selected.remove(component)
                                    }
                                }
                            })
                            .onEnded({ gesture in
                                model.selectionRect = .zero
                            })
                    )
                
                // grid
                Grid(width: width, height: height, origin: origin, scale: model.scale, gridSize: model.gridSize, dotSize: 2)
                    .onChange(of: rawMouse) { newValue in
                        model.mouse = CGPoint(x: rawMouse.x - frame.origin.x, y: height - rawMouse.y + frame.origin.y) - center
                    }
                
                // components
                ForEach(model.items) { item in
                    let selected = isSelected(item)
                    
                    item.symbol.view(origin: origin, gridSize: model.gridSize, scale: model.scale)
                        .gesture(
                            DragGesture()
                                .onChanged({ gesture in
                                    if !isSelected(item) {
                                        model.selected.removeAll()
                                        model.selected.insert(item)
                                    }
                                    
                                    var offsets: [Component: CGPoint] = [:]
                                    
                                    for selectedItem in model.selected {
                                        offsets[selectedItem] = selectedItem.symbol.position - item.symbol.position
                                    }
                                    
                                    withAnimation(.spring(response: 0.1)) {
                                        item.symbol.position = gesture.location.toLocal(world).snap(to: 1)
                                        
                                        for selectedItem in model.selected {
                                            if selectedItem != item {
                                                selectedItem.symbol.position = item.symbol.position + offsets[selectedItem]!
                                            }
                                        }
                                    }
                                })
                        )
                        .gesture(TapGesture().modifiers(.shift).onEnded({ gesture in
                            if isSelected(item) {
                                model.selected.remove(item)
                            } else {
                                model.selected.insert(item)
                            }
                        }))
                        .onTapGesture {
                            model.selected.removeAll()
                            model.selected.insert(item)
                        }
                        .contextMenu { // doesn't select component but whatever
                            Button("Test") {
                                
                            }
                        }
                        .shadow(color: selected ? .blue : .clear, radius: 10 * model.scale)
                }
                .drawingGroup()
                
                // selection rectangle
                Path { path in
                    path.addRect(model.selectionRect)
                }
                .fill(.white.opacity(0.1))
                
                Path { path in
                    path.addRect(model.selectionRect)
                }
                .stroke(style: StrokeStyle(lineWidth: 2))
                .foregroundColor(.white)
            }
            .layoutPriority(1)
            
            // canvas stats
            HStack {
                // stats
                let world = World(origin: model.origin, scale: model.gridSize * model.scale)
                let mousePos = model.mouse.toLocal(world)
                let viewPos = model.origin.toLocal(World(origin: .zero, scale: model.gridSize * model.scale * -1))
                
                Text("**Scale:** \(String(format: "%.2f", model.scale))")
                Text("**X:** \(Int((viewPos.x).rounded()))")
                Text("**Y:** \(Int((viewPos.y).rounded()))")
                Text("**Mouse X:** \(Int((mousePos.x).rounded()))")
                Text("**Mouse Y:** \(Int((mousePos.y).rounded()))")
                
                if model.selected.count > 0 {
                    Text("**Selected:** \(model.selected.count)")
                }
                
                Spacer()
            }
            .padding(8)
            .background(.background)
            .animation(.none, value: model.scale)
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
