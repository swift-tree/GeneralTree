import Tree

public protocol HasRoot {
  static var root: Self { get set }
}

public extension GeneralTree where Descendent == Forest<Element>, Element: Equatable, Element: HasRoot {
  mutating func inserting(_ path: LinkedList<Element>) {
    self = insert(path)
  }

  func insert(_ path: LinkedList<Element>) -> Self {
    switch path {
    case .empty:
      return self
    case let .node(value: firstInput, _):
      switch self {
      case .empty:
        return Tree(path)
      case .node(value: .root, var children):
        guard let index = children.forest.firstIndex(where: { $0.value == firstInput }) else {
          children.forest.append(Tree(path))
          return .node(value: .root, children)
        }
        let updatedTree = children.forest[index].insert(path)
        children.forest.remove(at: index)
        children.forest.insert(updatedTree, at: index)
        return .node(value: .root, children)
      case .node(value: firstInput, var children):
        let subtree = Tree(path.next)
        children.forest.append(contentsOf: subtree == .empty ? [] : [subtree])
        return .node(value: firstInput, children)
      case .node:
        return .node(value: .root, Descendent([self] + [Tree(path)]))
      }
    }
  }

  init(_ paths: [LinkedList<Element>]) {
    var tree = Self.empty
    paths.forEach { tree.inserting($0) }
    self = tree
  }
}

public extension GeneralTree where Descendent == Forest<Element>, Element: Equatable {
  func linkedLists(_ path: LinkedList<Element> = .empty) -> [LinkedList<Element>] {
    switch self {
    case .empty:
      return []
    case let .node(value: value, .noDescendent):
      return [path.insert(value)]
    case let .node(value: value, children):
      return children.forest.flatMap { $0.linkedLists(path.insert(value)) }
    }
  }
}
