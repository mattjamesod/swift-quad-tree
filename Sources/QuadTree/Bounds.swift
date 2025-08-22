
public struct Bounds<DataPoint: TwoDimensional> {
    let top: DataPoint.Part
    let bottom: DataPoint.Part
    let leading: DataPoint.Part
    let trailing: DataPoint.Part
    
    public init(top: DataPoint.Part, bottom: DataPoint.Part, leading: DataPoint.Part, trailing: DataPoint.Part) {
        self.top = top
        self.bottom = bottom
        self.leading = leading
        self.trailing = trailing
    }
    
    func contains(_ point: DataPoint) -> Bool {
        point.x >= leading && point.x <= trailing &&
        point.y >= bottom && point.y <= top
    }
    
    func intersects(_ bounds: Bounds<DataPoint>) -> Bool {
        max(self.leading, bounds.leading) <= min(self.trailing, bounds.trailing) &&
        max(self.bottom, bounds.bottom) <= min(self.top, bounds.top)
    }
    
    func fracture() -> [Bounds<DataPoint>] {
        let verticalMidpoint: DataPoint.Part = (self.top + self.bottom) / 2
        let horizontalMidpoint: DataPoint.Part = (self.leading + self.trailing) / 2
        
        return [
            Bounds(top: self.top, bottom: verticalMidpoint, leading: self.leading, trailing: horizontalMidpoint),
            Bounds(top: self.top, bottom: verticalMidpoint, leading: horizontalMidpoint, trailing: self.trailing),
            Bounds(top: verticalMidpoint, bottom: self.bottom, leading: self.leading, trailing: horizontalMidpoint),
            Bounds(top: verticalMidpoint, bottom: self.bottom, leading: horizontalMidpoint, trailing: self.trailing),
        ]
    }
}
