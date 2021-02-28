import Tree

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
