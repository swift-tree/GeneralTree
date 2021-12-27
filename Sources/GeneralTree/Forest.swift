import Tree


@dynamicMemberLookup
public struct Forest<T>: DescendentProtocol {
    public var forest: [GeneralTree<T>]
    
    public init(_ forest: GeneralTree<T> ...) { self.forest = forest }
    public init(_ forest: [GeneralTree<T>]) { self.forest = forest }
    
    public static var noDescendent: Forest { .init() }
    
    public subscript<A>(dynamicMember keyPath: KeyPath<[GeneralTree<T>], A>) -> A {
        get { forest[keyPath: keyPath] }
    }
}

public extension Forest {
    var height: Int {
        forest.map(\.height).max() ?? 0
    }
}

extension Forest: Equatable where T: Equatable {}
extension Forest: Hashable where T: Hashable {}
