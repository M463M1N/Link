import Foundation

public final class Signal<T>: Observable {
    typealias Value = T
    
    internal var observers: [Observer<T>] = []
    internal var children: [AnyWrapper] = []
    
    var last: T? {
        return stream.last
    }
    
    private var stream: [T] = [] {
        didSet {
            guard let value = stream.last else { return }
            updateObservers(value)
            updateChildren(value)
        }
    }
    
    public init() {}
    
    public init(_ initialValue: T) {
        stream.append(initialValue)
    }
    
    func bind(to observer: Observer<T>) {
        subscribe(observer)
    }
    
    public func send(_ value: T) {
        stream.append(value)
    }
    
    func bind(to signal: Signal<T>) {
        let ob = Observer<T> { [weak signal] value in
            signal?.send(value)
        }
        subscribe(ob)
    }
    
    func onNext(_ callBack: @escaping (T) -> Void) {
        let ob = Observer(callBack)
        subscribe(ob)
    }
    
    private func subscribe(_ observer: Observer<T>) {
        observers.append(observer)
        
        if let value = last { observer.send(value) }
    }
    
    private func subscribe(_ wrapper: AnyWrapper) {
        children.append(wrapper)
        
        if let value = last { wrapper.send(value) }
    }
    
}
