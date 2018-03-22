import Foundation

public final class Linker<T>: Observable {
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
    
    //MARK: - Initialize Methods
    public init() {}
    
    public init(_ initialValue: T) {
        stream.append(initialValue)
    }
    
    //MARK: - Basic Methods
    func bind(to observer: Observer<T>) {
        subscribe(observer)
    }
    
    public func send(_ value: T) {
        stream.append(value)
    }
    
    func bind(to signal: Linker<T>) {
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
    
    //MARK: - Higher Order Functions
    public func map<A>(_ f: @escaping (T) -> A) -> Linker<A> {
        let newLinker = Linker<A>()
        var wrapper = MapWrapper(mapping: f)
        wrapper.wrapped = newLinker
        subscribe(wrapper)
        return newLinker
    }
    
    public func filter(_ f: @escaping (T) -> Bool) -> Linker<T> {
        let newLinker = Linker<T>()
        var wrapper = FilterWrapper(condition: f)
        wrapper.wrapped = newLinker
        subscribe(wrapper)
        return newLinker
    }
    
    public func merge<A>(with other: Linker<A>) -> Linker<(T, A)> {
        let newLinker = Linker<(T, A)>()
        let wrapper = MergeWrapper(self, other)
        wrapper.wrapped = newLinker
        other.onNext { [weak wrapper](value) in
            wrapper?._send(value)
        }
        subscribe(wrapper)
        return newLinker
    }
}
