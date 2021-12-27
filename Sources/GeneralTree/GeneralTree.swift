import Tree

public typealias GeneralTree<T> = Tree<T, Forest<T>>

@resultBuilder
public enum GeneralTreeBuilder<T> {
    public static func buildBlock(_ contents: [GeneralTree<T>]) -> Forest<T> {
        Forest(contents)
    }
    
    public static func buildBlock(_ contents: GeneralTree<T>...) -> Forest<T> {
        Forest(contents)
    }
    
    public static func buildBlock(_ children: Forest<T>) -> Forest<T> {
        children
    }
}

public extension GeneralTree where Descendent == Forest<Element> {
    init(_ value: Element, @GeneralTreeBuilder <Element> builder: () -> Forest<Element>) {
        self = .node(value: value, builder())
    }
    
    init(_ value: Element) {
        self = .leaf(value)
    }
}

public extension GeneralTree where Descendent == Forest<Element>, Element: Sequence {
    private struct MergedSequence<Base1: Sequence, Base2: Sequence>: Sequence
    where Base1.Element == Base2.Element {
        let base1: Base1
        let base2: Base2
        
        init(base1: Base1, base2: Base2) {
            self.base1 = base1
            self.base2 = base2
        }
        
        public func makeIterator() -> Iterator {
            Iterator(base1: base1.makeIterator(), base2: base2.makeIterator())
        }
        
        public struct Iterator: IteratorProtocol {
            @usableFromInline
            var base1: Base1.Iterator
            var base2: Base2.Iterator
            
            init(base1: Base1.Iterator, base2: Base2.Iterator) {
                self.base1 = base1
                self.base2 = base2
            }
            
            public mutating func next() -> Base1.Element? {
                base1.next() ?? base2.next()
            }
        }
    }
    
    func append() -> [[Element.Element]] { _append() }
    
    private func _append(_ sequence: [Element.Element] = []) -> [[Element.Element]] {
        switch self {
        case .empty:
            return [sequence]
            
        case let .node(value: value, children):
            let mergedSequence = Array(MergedSequence(base1: sequence, base2: value))
            return children.isEmpty ? [mergedSequence] : children.forest.flatMap { $0._append(mergedSequence) }
        }
    }
}
