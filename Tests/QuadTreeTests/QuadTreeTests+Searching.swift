import Testing
import Foundation
@testable import QuadTree

extension QuadTreeTests {
    @Suite("Searching a QuadTree")
    struct Searching {
        let tree = QuadTree<Coordinate>.testInstance()
        
        @Test("Returns nothing when bounds don't intersect")
        func noIntersection() {
            tree.add(.init(x: 10, y: 10))
            tree.add(.init(x: -140, y: -140))
            let result = tree.search(in: .init(top: -256, bottom: -128, leading: -128, trailing: -256))
            
            #expect(result.isEmpty)
        }
        
        @Test("Returns points from overlapping areas")
        func someIntersection() {
            let sixty_four_square = Coordinate(x: 64, y: 64) // in tree and search
            let one_ninety_two_square = Coordinate(x: 192, y: 192) // in tree, but not search
            let minus_sixty_four_square = Coordinate(x: -64, y: -64) // in search, but not tree
            let zero_square = Coordinate(x: 0, y: 0) // boundary of tree, not of search
            let one_twenty_eight_square = Coordinate(x: 128, y: 128) // boundary of search, but not of tree
            let zero_one_twenty_eight = Coordinate(x: 0, y: 128) // boundary of both tree and search
            
            tree.add(sixty_four_square)
            tree.add(one_ninety_two_square)
            tree.add(minus_sixty_four_square)
            tree.add(zero_square)
            tree.add(one_twenty_eight_square)
            tree.add(zero_one_twenty_eight)
            
            let result = tree.search(in: .init(top: 128, bottom: -128, leading: -128, trailing: 128))
            
            #expect(result == Set([sixty_four_square, zero_square, one_twenty_eight_square, zero_one_twenty_eight]))
        }
    }
}
