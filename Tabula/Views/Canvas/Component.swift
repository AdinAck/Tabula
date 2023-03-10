//
//  Component.swift
//  Tabula
//
//  Created by Adin Ackerman on 3/9/23.
//

import Foundation

class Component: ObservableObject, Identifiable {
    @Published var symbol: Symbol
    @Published var footprint: Footprint = Footprint()
    
    let id = UUID()
    
    init(symbol: Symbol) {
        self.symbol = symbol
    }
}
