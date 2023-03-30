//
//  ContentView.swift
//  Metal-Test
//
//  Created by Adin Ackerman on 3/19/23.
//

import AppKit
import SwiftUI
import MetalKit

struct ContentView: NSViewRepresentable {
    typealias NSViewType = MTKView
    
    func makeCoordinator() -> Renderer<Self> {
        Renderer<Self>(self)
    }
    
    func makeNSView(context: Context) -> NSViewType {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 120
        mtkView.enableSetNeedsDisplay = true
        
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }
        
        mtkView.framebufferOnly = false
        
        return mtkView
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
