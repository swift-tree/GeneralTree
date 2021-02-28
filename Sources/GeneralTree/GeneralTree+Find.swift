import Tree

extension GeneralTree where Descendent == Forest<Element>, Element: Equatable {
  public func remove(at indices: LinkedList<Int>) -> Self {
    switch (self, indices) {
    case (.empty, _):
      return .empty
    case (.node, .empty):
      return self
    case (.node(value: let value, var children), let .node(value: lastIndex, .init(.empty))):
      children.forest.remove(at: lastIndex)
      let forest = children.forest
      return .node(value: value, .init(forest))
    case (.node(value: _, let children), let .node(value: index, child)):
      return children.forest[index].remove(at: child.next)
    }
  }
}

public extension GeneralTree where Descendent == Forest<Element>, Element: Equatable {
  private func find(trees e: Element) -> [Self] {
    switch self {
    case .empty:
      return []
    case .node(value: e, _):
      return [self]
    case .node(value: _, let children):
      return children.forest.flatMap { $0.find(trees: e) }
    }
  }

  func find(_ e: Element) -> Self {
    let subtrees = find(trees: e)
    return subtrees.isEmpty ? .empty : .node(value: e, .init(subtrees.flatMap { $0.descentent?.forest ?? [] }))
  }

  func find(at indices: LinkedList<Int>) -> Self {
    switch (self, indices) {
    case (.empty, _):
      return .empty
    case (.node, .empty):
      return self
    case (.node(value: _, let children), let .node(value: lastIndex, .init(.empty))):
      return children.forest[lastIndex]
    case (.node(value: _, let children), let .node(value: index, child)):
      return children.forest[index].find(at: child.next)
    }
  }

  subscript(indices: LinkedList<Int>) -> Element? {
    find(at: indices).value
  }
}
