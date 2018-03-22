//
//  MapWrapper.swift
//  Link
//
//  Created by M1N on 22/03/2018.
//  Copyright © 2018 M1N. All rights reserved.
//

import Foundation

struct MapWrapper<A, B>: Wrapper, AnyWrapper {
    var wrapped: Signal<B>?
    private let mapping: (A) -> B
    
    init(mapping: @escaping (A) -> B) {
        self.mapping = mapping
    }
    
    func send(_ value: A) {
        let new = mapping(value)
        wrapped?.send(new)
    }
}
