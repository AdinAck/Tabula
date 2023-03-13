//
//  Component.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/9/23.
//

import Foundation

class Component: ObservableObject, Identifiable, Hashable {
    @Published var symbol: Symbol
    @Published var footprint: Footprint = Footprint()
    
    let id = UUID()
    
    init(symbol: Symbol) {
        self.symbol = symbol
    }
    
    static func == (lhs: Component, rhs: Component) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
