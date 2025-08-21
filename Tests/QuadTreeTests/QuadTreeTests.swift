import Testing
import Foundation
@testable import QuadTree

struct Coordinate: Identifiable, TwoDimensional {
    var id: UUID = UUID()
    var x: Double
    var y: Double
}

extension QuadTree<Coordinate> {
    static func testInstance() -> QuadTree<Coordinate> {
        QuadTree<Coordinate>(bounds: .init(top: 256, bottom: 0, leading: 0, trailing: 256), capacity: 3)
    }
}

struct QuadTreeTests {
    let tree = QuadTree<Coordinate>.testInstance()
    
    @Test("Adding an out of bound point does nothing")
    func addingOutOfBounds() {
        tree.add(.init(x: -10, y: -10))
        #expect(tree.points.isEmpty)
    }
    
    @Test("Adding points within bounds are added to internal storage, until capacity reached")
    func addingPointsWithinCapcity() {
        tree.add(.init(x: 10, y: 10))
        tree.add(.init(x: 20, y: 20))
        tree.add(.init(x: 30, y: 30))
        tree.add(.init(x: 40, y: 40))
        
        #expect(tree.points.count == 3)
        #expect(tree.quadrants != nil)
    }
    
    @Test("Points go into correct quadrants after reaching capacity")
    func addingPointsToQuadrants() {
        let basicPoints = [
            Coordinate(x: 10, y: 10),
            Coordinate(x: 10, y: 10),
            Coordinate(x: 10, y: 10),
        ]
        
        tree.add(basicPoints[0])
        tree.add(basicPoints[1])
        tree.add(basicPoints[2])
        
        let topLeading: Coordinate = .init(x: 64, y: 192)
        let topTrailing: Coordinate = .init(x: 192, y: 192)
        let bottomLeading: Coordinate = .init(x: 64, y: 64)
        let bottomTrailing: Coordinate = .init(x: 192, y: 64)
        
        tree.add(topLeading)
        tree.add(topTrailing)
        tree.add(bottomLeading)
        tree.add(bottomTrailing)
        
        #expect(tree.points == Set(basicPoints))
        #expect(tree.quadrants?.topLeading.points == Set([topLeading]))
        #expect(tree.quadrants?.topTrailing.points == Set([topTrailing]))
        #expect(tree.quadrants?.bottomLeading.points == Set([bottomLeading]))
        #expect(tree.quadrants?.bottomTrailing.points == Set([bottomTrailing]))
    }
}
