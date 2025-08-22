
public protocol TwoDimensional: Hashable {
    associatedtype Part: FloatingPoint, Comparable
    var x: Part { get }
    var y: Part { get }
}
