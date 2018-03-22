//
//  FilterWrapper.swift
//  Link
//
//  Created by M1N on 22/03/2018.
//  Copyright © 2018 M1N. All rights reserved.
//

import Foundation

struct FilterWrapper<A>: Wrapper, AnyWrapper {
    var wrapped: Linker<A>?
    private let condition: (A) -> Bool
    
    init(condition: @escaping (A) -> Bool) {
        self.condition = condition
    }
    
    func send(_ value: A) {
        guard condition(value) else { return }
        
        wrapped?.send(value)
    }
}
