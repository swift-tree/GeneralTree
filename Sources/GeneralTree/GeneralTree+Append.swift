import Tree

public extension GeneralTree where Descendent == Forest<Element>, Element: Equatable {
  init(_ path: LinkedList<Element>) {
    self = Self.empty.append(path)
  }

  func append(_ path: LinkedList<Element>) -> Self {
    switch (self, path) {
    case (.empty, .empty):
      return .empty
    case (.node, .empty):
      return self
    case let (.empty, .node(value: value, _)):
      let new: Self = .leaf(value)
      return path.next == .empty ? new : new.append(path.next) // path.next.map(new.append) ?? new
    case (.node(value: let selfValue, var children), let .node(value: value, _)):
      let new: Self = .leaf(value)
      let add = path.next == .empty ? new : new.append(path.next) // path.next.map(new.append) ?? new
      children.forest.append(add)
      return .node(value: selfValue, children)
    }
  }
}
