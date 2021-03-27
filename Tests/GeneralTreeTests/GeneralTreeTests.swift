import GeneralTree
import Tree
import XCTest

extension Int: HasRoot {
  public static var root = Int.max
}

final class GeneralTreeTests: XCTestCase {
  private typealias GeneralTreeInt = GeneralTree<Int>
  private var tree: GeneralTreeInt!
  private var capturedItems: [Int]!

  override func setUp() {
    super.setUp()

    tree = .empty
    capturedItems = []
  }

  override func tearDown() {
    tree = nil
    capturedItems = nil

    super.tearDown()
  }

  func test_init_paths() {
    tree = GeneralTreeInt(paths: [[1], [2], [1, 3]])

    XCTAssertEqual(
      tree,
      .node(
        value: Int.max,
        .init(
          .node(value: 1, .init(.node(value: 3, .noDescendent))),
          .node(value: 2, .noDescendent)
        )
      )
    )
  }

  func test_inserting_on_empty() {
    tree.inserting(.init([1]))

    XCTAssertEqual(tree, .leaf(1))
  }

  func test_insert_on_empty_recurring() {
    let oneTree = tree.insert(.leaf(1)).insert(.leaf(1))

    XCTAssertEqual(oneTree, .leaf(1))
  }

  func test_insert_on_one_second_different() {
    let oneTwoTree = tree.insert(.leaf(1)).insert(.leaf(2))

    XCTAssertEqual(oneTwoTree, .node(value: Int.max, .init(
      .node(value: 1, .noDescendent),
      .node(value: 2, .noDescendent)
    )))
  }

  func test_insert_already_has_two_levels_sharing_root() {
    let tree = GeneralTreeInt.empty
      .insert(.leaf(1))
      .insert(.leaf(2))
      .insert(.node(value: 1, .init(.leaf(3))))

    XCTAssertEqual(
      tree,
      .node(
        value: Int.max,
        .init(
          .node(value: 1, .init(.node(value: 3, .noDescendent))),
          .node(value: 2, .noDescendent)
        )
      )
    )
  }

  func test_insert_already_has_two_levels_sharing_root1() {
    let newTree = tree.insert(.leaf(1)).insert(.node(value: 1, .init(.leaf(3)))).insert(.node(value: 2, .init(.leaf(3))))

    XCTAssertEqual(
      newTree,
      .node(
        value: Int.max,
        .init(
          .node(value: 1, .init(.node(value: 3, .noDescendent))),
          .node(value: 2, .init(.node(value: 3, .noDescendent)))
        )
      )
    )
  }

  func test_insert_already_has_two_levels_sharing_root2() {
    let newTree = tree
      .insert(.node(value: 1, .init(.leaf(3))))
      .insert(.node(value: 2, .init(.leaf(3))))

    XCTAssertEqual(
      newTree,
      .node(
        value: Int.max,
        .init(
          .node(value: 1, .init(.node(value: 3, .noDescendent))),
          .node(value: 2, .init(.node(value: 3, .noDescendent)))
        )
      )
    )
  }

  func test_insert_already_has_two_levels_sharing_root3() {
    let newTree = tree
      .insert(.init([1, 3]))
      .insert(.init([2, 3]))

    XCTAssertEqual(
      newTree,
      .node(
        value: Int.max,
        .init(
          .init([1, 3]),
          .init([2, 3])
        )
      )
    )
  }

  func test_insert_already_has_two_levels_sharing_root4() {
    let newTree = GeneralTreeInt([1, 3])
      .insert(.init([2, 3]))

    XCTAssertEqual(
      newTree,
      .node(
        value: Int.max,
        .init(
          .init([1, 3]),
          .init([2, 3])
        )
      )
    )
  }

  func test_insert_already_has_two_levels_sharing_root5() {
    tree.inserting(.init([1, 3]))
    tree.inserting(.init([2, 3]))

    XCTAssertEqual(
      tree,
      .node(
        value: Int.max,
        .init(
          .init([1, 3]),
          .init([2, 3])
        )
      )
    )
  }

  func test_insert_on_one_second_different1() {
    var tree = GeneralTreeInt.empty

    tree.inserting([1])
    tree.inserting([2])

    XCTAssertEqual(tree, .node(value: Int.max, .init(
      .node(value: 1, .noDescendent),
      .node(value: 2, .noDescendent)
    )))
  }

  func test_insert_vector_on_empty() {
    tree.inserting(.node(value: 1, .init(.node(value: 2, .init(.leaf(3))))))

    XCTAssertEqual(
      tree,
      .node(
        value: 1,
        .init(.node(
          value: 2,
          .init(.node(value: 3, .noDescendent)
          )
        )
        )
      )
    )
  }

  func test_insert_different_vectors() {
    var newTree = tree.insert(.node(value: 1, .init(.leaf(2)))).insert(.node(value: 3, .init(.leaf(4))))

    XCTAssertEqual(
      newTree,
      .node(value: Int.max, .init(
        .node(value: 1, .init(.leaf(2))),
        .node(value: 3, .init(.leaf(4)))
      ))
    )

    newTree = newTree.insert(.node(value: 5, .init(.leaf(6))))

    XCTAssertEqual(
      newTree,
      .node(value: Int.max, .init(
        .node(value: 1, .init(.leaf(2))),
        .node(value: 3, .init(.leaf(4))),
        .node(value: 5, .init(.leaf(6)))
      ))
    )
  }

  func test_traversals_preOrder() {
    tree = .node(
      value: 1,
      .init(.leaf(11), .leaf(12), .leaf(13))
    )

    tree.traverse(method: .preOrder) { [weak self] value, _ in
      self?.capturedItems.append(value)
    }

    XCTAssertEqual(capturedItems, [1, 11, 12, 13])
  }

  func test_height() {
    tree = .node(
      value: 1,
      .init(.leaf(11), .leaf(12), .leaf(13))
    )
    XCTAssertEqual(tree.height, 2)
  }

  func test_traversals_postOrder() {
    tree = .node(
      value: 1,
      .init(.leaf(11), .leaf(12), .leaf(13))
    )

    tree.traverse(method: .postOrder) { [weak self] value, _ in
      self?.capturedItems.append(value)
    }

    XCTAssertEqual(capturedItems, [11, 12, 13, 1])
  }

  func test_find() {
    tree = .node(
      value: 1,
      .init(
        .leaf(11),
        .leaf(12),
        .node(
          value: 2,
          .init(
            .leaf(11),
            .leaf(12),
            .leaf(13)
          )
        )
      )
    )

    XCTAssertEqual(
      tree.find(2),
      .node(
        value: 2,
        .init(
          .leaf(11),
          .leaf(12),
          .leaf(13)
        )
      )
    )
  }

  func test_find2() {
    tree = .node(
      value: 1,
      .init(
        .leaf(11),
        .leaf(12),
        .node(
          value: 2,
          .init(
            .leaf(11),
            .leaf(12),
            .leaf(13)
          )
        )
      )
    )

    XCTAssertEqual(
      tree.find(11),
      .leaf(11)
    )
  }

  func test_linkedlists_tree_empty() {
    XCTAssertEqual(GeneralTreeInt.empty.linkedLists(), [])
  }

  func test_linkedlists_tree_init() {
    XCTAssertEqual(GeneralTree(LinkedList([1])), .leaf(1))
    XCTAssertEqual(
      GeneralTree(LinkedList([1, 2, 3])),
      .node(
        value: 1,
        .init(
          .node(
            value: 2,
            .init(
              .node(
                value: 3,
                .noDescendent
              )
            )
          )
        )
      )
    )
  }

  func test_linkedlists_tree() {
    let searchingTree: GeneralTreeInt = .node(
      value: 12,
      .init(
        .leaf(0),
        .leaf(9),
        .leaf(8),
        .leaf(7)
      )
    )

    tree = .node(
      value: 1,
      .init(
        .leaf(11),
        .leaf(12),
        .node(
          value: 2,
          .init(
            .leaf(11),
            searchingTree,
            .leaf(13),
            .leaf(12)
          )
        )
      )
    )

    XCTAssertEqual(
      tree.linkedLists(),
      [
        .node(value: 1, .init(.node(value: 11, .init(.empty)))),
        .node(value: 1, .init(.node(value: 12, .init(.empty)))), .node(value: 1, .init(.node(value: 2, .init(.node(value: 11, .init(.empty)))))), .node(value: 1, .init(.node(value: 2, .init(.node(value: 12, .init(.node(value: 0, .init(.empty)))))))), .node(value: 1, .init(.node(value: 2, .init(.node(value: 12, .init(.node(value: 9, .init(.empty)))))))), .node(value: 1, .init(.node(value: 2, .init(.node(value: 12, .init(.node(value: 8, .init(.empty)))))))), .node(value: 1, .init(.node(value: 2, .init(.node(value: 12, .init(.node(value: 7, .init(.empty)))))))), .node(value: 1, .init(.node(value: 2, .init(.node(value: 13, .init(.empty)))))), .node(value: 1, .init(.node(value: 2, .init(.node(value: 12, .init(.empty)))))),
      ]
    )
  }

  func test_find_at_indices_subscript() {
    tree = .node(
      value: 1,
      .init(
        .leaf(11),
        .leaf(12),
        .node(
          value: 2,
          .init(
            .leaf(11),
            .node(
              value: 12,
              .init(
                .leaf(0),
                .leaf(9),
                .leaf(8),
                .leaf(7)
              )
            ),
            .leaf(13),
            .leaf(12)
          )
        )
      )
    )

    XCTAssertEqual(tree[[2, 1, 3]], 7)
  }

  func test_remove_at_indices() {
    tree = .node(
      value: 1,
      .init(
        .leaf(11),
        .leaf(12),
        .node(
          value: 2,
          .init(
            .leaf(11),
            .node(
              value: 12,
              .init(
                .leaf(0),
                .leaf(9),
                .leaf(8),
                .leaf(7)
              )
            ),
            .leaf(13),
            .leaf(12)
          )
        )
      )
    )

    XCTAssertEqual(tree.remove(at: [2, 1, 3]), .node(
      value: 12,
      .init(
        .leaf(0),
        .leaf(9),
        .leaf(8)
      )
    ))
  }

  func test_find_at_indices() {
    tree = .node(
      value: 1,
      .init(
        .leaf(11),
        .leaf(12),
        .node(
          value: 2,
          .init(
            .leaf(11),
            .node(
              value: 12,
              .init(
                .leaf(0),
                .leaf(9),
                .leaf(8),
                .leaf(7)
              )
            ),
            .leaf(13),
            .leaf(12)
          )
        )
      )
    )

    XCTAssertEqual(tree.find(at: [2, 1, 3]), .leaf(7))
  }

  func test_find_at_indices_first_element() {
    tree = .node(
      value: 1,
      .init(
        .leaf(11),
        .leaf(12),
        .node(
          value: 2,
          .init(
            .leaf(11),
            .node(
              value: 12,
              .init(
                .leaf(0),
                .leaf(9),
                .leaf(8),
                .leaf(7)
              )
            ),
            .leaf(13),
            .leaf(12)
          )
        )
      )
    )

    XCTAssertEqual(tree.find(at: [0]), .leaf(11))
  }

  func test_find_at_indices_empty_indices() {
    tree = .node(
      value: 1,
      .init(
        .leaf(11),
        .leaf(12),
        .node(
          value: 2,
          .init(
            .leaf(11),
            .node(
              value: 12,
              .init(
                .leaf(0),
                .leaf(9),
                .leaf(8),
                .leaf(7)
              )
            ),
            .leaf(13),
            .leaf(12)
          )
        )
      )
    )

    XCTAssertEqual(tree.find(at: .empty), tree)
  }

  func test_find_at_indices_on_empty() {
    XCTAssertEqual(tree.find(at: [0, 1, 2, 3, 4, 5]), .empty)
  }

  func test_find_subtree() {
    tree = .node(
      value: 1,
      .init(
        .leaf(11),
        .leaf(12),
        .node(
          value: 2,
          .init(
            .leaf(11),
            .node(
              value: 12,
              .init(
                .leaf(0),
                .leaf(9),
                .leaf(8),
                .leaf(7)
              )
            ),
            .leaf(13),
            .leaf(12)
          )
        )
      )
    )

    XCTAssertEqual(tree.find(at: [2, 1, 3]), .leaf(7))
  }

  func test_find3() {
    tree = .node(
      value: 1,
      .init(
        .leaf(11),
        .leaf(12),
        .node(
          value: 2,
          .init(
            .leaf(11),
            .node(
              value: 12,
              .init(
                .leaf(0),
                .leaf(9),
                .leaf(8),
                .leaf(7)
              )
            ),
            .leaf(13),
            .leaf(12)
          )
        )
      )
    )

    XCTAssertEqual(
      tree.find(12),
      .node(
        value: 12,
        .init(
          .leaf(0),
          .leaf(9),
          .leaf(8),
          .leaf(7)
        )
      )
    )
  }

  static var allTests = [
    //    ("test_init", test_init),
    //    ("test_traversals_preOrder", test_traversals_preOrder),
    //    ("test_traversals_inOrder", test_traversals_inOrder),
    //    ("test_traversals_postOrder", test_traversals_postOrder),
    //    ("test_string_preOrder", test_string_preOrder),
    //    ("test_min_no_right_tree", test_min_no_right_tree),
    //    ("test_min_right_tree", test_min_right_tree),
    //    ("test_remove_one_childed", test_remove_one_childed),
    //    ("test_remove_root_1_level", test_remove_root_1_level),
    //    ("test_remove_two_children_node", test_remove_two_children_node),
    //    ("test_remove_root_two_children_node", test_remove_root_two_children_node),
    //    ("test_removeTree_root_1_level", test_removeTree_root_1_level),
    //    ("test_removeTree_root_3_level", test_removeTree_root_3_level),
    //    ("test_removeTree_not_containing", test_removeTree_not_containing),
    //    ("test_removeTree_leaf_2_level", test_removeTree_leaf_2_level),
    //    ("test_removeTree_leaf_3_level", test_removeTree_leaf_3_level),
    //    ("test_contains_other_tree", test_contains_other_tree),
    //    ("test_contains_bool", test_contains_bool),
    ("test_height", test_height),
  ]
}
