import Foundation

public struct Observer<T> {
    private let callBack: (T) -> Void
    public init(_ callBack: @escaping (T) -> Void) {
        self.callBack = callBack
    }
    
    public func send(_ value: T) {
        callBack(value)
    }
}
