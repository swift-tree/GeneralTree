import Tree

public struct ForestSet<T: Hashable>: DescendentProtocol, Hashable {
  public var forest: Set<MultiWayTree<T>>

  public init(_ forest: MultiWayTree<T> ...) { self.forest = Set(forest) }
  public init(_ forest: Set<MultiWayTree<T>>) { self.forest = forest }

  public static var noDescendent: ForestSet { .init() }
}

public struct Forest<T>: DescendentProtocol {
  public var forest: [GeneralTree<T>]

  public init(_ forest: GeneralTree<T> ...) { self.forest = forest }
  public init(_ forest: [GeneralTree<T>]) { self.forest = forest }

  public static var noDescendent: Forest { .init() }
}

public extension Forest {
  var height: Int {
    forest.map { $0.height }.max() ?? 0
  }
}

public extension ForestSet {
  var height: Int {
    forest.map { $0.height }.max() ?? 0
  }
}

extension Forest: Equatable where T: Equatable {}
extension Forest: Hashable where T: Hashable {}
