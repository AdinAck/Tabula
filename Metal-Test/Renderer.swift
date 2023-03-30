//
//  Renderer.swift
//  Metal-Test
//
//  Created by Adin Ackerman on 3/19/23.
//

import Foundation
import SwiftUI
import MetalKit

class Renderer<ViewType: NSViewRepresentable>: NSObject, MTKViewDelegate {
    var parent: ViewType
    var metalDevice: MTLDevice!
    var metalCommandQueue: MTLCommandQueue!
    let pipelineState: MTLRenderPipelineState
    let vertexBuffer: MTLBuffer
    
    init(_ parent: ViewType) {
        self.parent = parent
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            self.metalDevice = metalDevice
        }
        
        self.metalCommandQueue = metalDevice.makeCommandQueue()
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = metalDevice.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        

        try! pipelineState = metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
        let verticies = [
            Vertex(position: [-1, -1], color: [1, 0, 0, 1]),
            Vertex(position: [-1, 1], color: [0, 1, 0, 1]),
            Vertex(position: [1, 1], color: [0, 0, 1, 1]),
            Vertex(position: [-1, -1], color: [1, 0, 0, 1]),
            Vertex(position: [1, 1], color: [0, 0, 1, 1]),
            Vertex(position: [1, -1], color: [0, 1, 0, 1]),
        ]
        vertexBuffer = metalDevice.makeBuffer(bytes: verticies, length: verticies.count * MemoryLayout<Vertex>.stride, options: [])!
        super.init()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else { return }
        
        let commandBuffer = metalCommandQueue.makeCommandBuffer()
        
        let renderPassDescriptor = view.currentRenderPassDescriptor
        renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColorMake(0, 0.5, 0.5, 1)
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear
        renderPassDescriptor?.colorAttachments[0].storeAction = .store
        
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
        
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
        
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
}
