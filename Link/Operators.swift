import Foundation

precedencegroup LinkerPrecedenceGroup {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: LogicalDisjunctionPrecedence
}

infix operator <- : LinkerPrecedenceGroup

public func <- <T>(observer: Observer<T>, linker: Linker<T>) {
    linker.bind(to: observer)
}

public func <- <T>(lhs: Linker<T>, rhs: Linker<T>) {
    rhs.bind(to: lhs)
}
