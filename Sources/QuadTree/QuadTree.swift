
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
    
    public init(bounds: Bounds<DataPoint>, capacity: Int = 1) {
        self.bounds = bounds
        self.capacity = capacity
    }
    
    var points: Set<DataPoint> = Set([])
    var quadrants: Quadrants? = nil
    
    @discardableResult
    public func add(_ point: DataPoint) -> Bool {
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
    
    public func search(in rect: Bounds<DataPoint>) -> Set<DataPoint> {
        Set([])
    }
    
    private func fracture() -> Quadrants {
        guard quadrants == nil else {
            return quadrants!
        }
        
        let quadBounds = self.bounds.fracture()
        
        self.quadrants = Quadrants(
            topLeading: .init(bounds: quadBounds[0], capacity: self.capacity),
            topTrailing: .init(bounds: quadBounds[1], capacity: self.capacity),
            bottomLeading: .init(bounds: quadBounds[2], capacity: self.capacity),
            bottomTrailing: .init(bounds: quadBounds[3], capacity: self.capacity)
        )
        
        return self.quadrants!
    }
}
