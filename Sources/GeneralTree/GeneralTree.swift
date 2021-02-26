import Tree

public typealias GeneralTree<T> = Tree<T, Forest<T>>
public typealias MultiWayTree<T> = Tree<T, ForestSet<T>> where T: Hashable

public extension GeneralTree {
  static func leaf(_ e: Element) -> Self { .node(value: e, .noDescendent)}
}
