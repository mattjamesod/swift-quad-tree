
protocol TwoDimensional: Hashable {
    associatedtype Part: FloatingPoint, Comparable
    var x: Part { get }
    var y: Part { get }
}

struct Bounds<DataPoint: TwoDimensional> {
    let top: DataPoint.Part
    let bottom: DataPoint.Part
    let leading: DataPoint.Part
    let trailing: DataPoint.Part
    
    func contains(_ point: DataPoint) -> Bool {
        point.x > leading && point.x < trailing &&
        point.y > bottom && point.y < top
    }
    
    func fracture() -> [Bounds<DataPoint>] {
        [
            Bounds(top: self.top, bottom: self.bottom / 2, leading: self.leading, trailing: self.trailing / 2),
            Bounds(top: self.top, bottom: self.bottom / 2, leading: self.leading / 2, trailing: self.trailing),
            Bounds(top: self.top / 2, bottom: self.bottom, leading: self.leading, trailing: self.trailing / 2),
            Bounds(top: self.top / 2, bottom: self.bottom, leading: self.leading / 2, trailing: self.trailing),
        ]
    }
}

class QuadTree<DataPoint: TwoDimensional> {
    struct Quadrants {
        let topLeading: QuadTree<DataPoint>
        let topTrailing: QuadTree<DataPoint>
        let bottomLeading: QuadTree<DataPoint>
        let bottomTrailing: QuadTree<DataPoint>
    }
    
    /// Each node in the tree (of which this is one) can hold a number of data points directly, beyond which
    /// new points are given to child quandrants
    private let capacity: Int
    private let bounds: Bounds<DataPoint>
    
    init(bounds: Bounds<DataPoint>, capacity: Int = 1) {
        self.bounds = bounds
        self.capacity = capacity
    }
    
    private var points: Set<DataPoint> = Set([])
    private var quandrants: Quadrants? = nil
    
    func add(_ point: DataPoint) -> Bool {
        guard self.bounds.contains(point) else { return false }
        
        if self.points.count < self.capacity {
            self.points.insert(point)
            return true
        }
        
        let quadrants = fracture()
        
        if quadrants.topLeading.add(point) { return true }
        if quadrants.topTrailing.add(point) { return true }
        if quadrants.bottomLeading.add(point) { return true }
        if quadrants.bottomTrailing.add(point) { return true }
        
        fatalError()
    }
    
    func search(in rect: Bounds<DataPoint>) -> Set<DataPoint> {
        Set([])
    }
    
    private func fracture() -> Quadrants {
        guard quandrants == nil else {
            return quandrants!
        }
        
        let quadBounds = self.bounds.fracture()
        
        self.quandrants = Quadrants(
            topLeading: .init(bounds: quadBounds[0], capacity: self.capacity),
            topTrailing: .init(bounds: quadBounds[1], capacity: self.capacity),
            bottomLeading: .init(bounds: quadBounds[2], capacity: self.capacity),
            bottomTrailing: .init(bounds: quadBounds[3], capacity: self.capacity)
        )
        
        return self.quandrants!
    }
}
