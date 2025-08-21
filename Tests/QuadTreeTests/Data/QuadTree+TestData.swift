import Foundation
@testable import QuadTree

extension QuadTree<Coordinate> {
    static func testInstance() -> QuadTree<Coordinate> {
        QuadTree<Coordinate>(bounds: .init(top: 256, bottom: 0, leading: 0, trailing: 256), capacity: 1)
    }
}
