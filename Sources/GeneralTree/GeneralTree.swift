import Tree

public typealias GeneralTree<T> = Tree<T, Forest<T>>
public typealias MultiWayTree<T> = Tree<T, ForestSet<T>> where T: Hashable

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
