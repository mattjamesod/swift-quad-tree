import Foundation
@testable import QuadTree

struct Coordinate: Identifiable, TwoDimensional {
    var id: UUID = UUID()
    var x: Double
    var y: Double
}

