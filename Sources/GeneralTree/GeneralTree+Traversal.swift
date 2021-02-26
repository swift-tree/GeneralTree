import Tree

public enum DepthFirstTraversal {
  case preOrder
  case postOrder
}

public extension GeneralTree where Children == Forest<Element>, Element: Equatable {
  func traverse(
    initialPath: LinkedList<Element> = .empty,
    method: DepthFirstTraversal,
    visit: @escaping (Element, LinkedList<Element>) -> ()
  ) {
    guard case let .node(value: value, children) = self else { return }
    let path = initialPath.insert(value)
    switch method {
    case .preOrder:
      visit(value, path)
      children.forest.forEach{ tree in
        tree.traverse(initialPath: path, method: method, visit: visit)
      }
    case .postOrder:
      children.forest.forEach{ tree in
        tree.traverse(initialPath: path, method: method, visit: visit)
      }
      visit(value, path)
    }
  }
}
