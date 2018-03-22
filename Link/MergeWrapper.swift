//
//  MergeWrapper.swift
//  Link
//
//  Created by M1N on 22/03/2018.
//  Copyright © 2018 M1N. All rights reserved.
//

import Foundation
final class MergeWrapper<A, B>: Wrapper, AnyWrapper {
    var wrapped: Linker<(A, B)>?
    private weak var parentA: Linker<A>?
    private weak var parentB: Linker<B>?
    
    init(_ a: Linker<A>, _ b: Linker<B>) {
        parentA = a
        parentB = b
    }
    
    func _send(_ value: B) {
        guard let otherValue = parentA?.last else { return }
        let merge = (otherValue, value)
        wrapped?.send(merge)
    }
    
    func send(_ value: A) {
        guard let otherValue = parentB?.last else { return }
        let merge = (value, otherValue)
        wrapped?.send(merge)
    }
}
