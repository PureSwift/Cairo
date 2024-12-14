//
//  Pattern.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 1/31/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import CCairo

/// Represents a source when drawing onto a surface. 
///
/// There are different subtypes of patterns, for different types of sources.
public final class Pattern {
    
    // MARK: - Properties
    
    internal var internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        
        cairo_pattern_destroy(internalPointer)
    }
    
    internal init(_ internalPointer: OpaquePointer) {
        
        self.internalPointer = internalPointer
    }
    
    public init(surface: Surface) {
        
        self.internalPointer = cairo_pattern_create_for_surface(surface.internalPointer)
    }
    
    public init(color: (red: Double, green: Double, blue: Double)) {
        
        self.internalPointer = cairo_pattern_create_rgb(color.red, color.green, color.blue)
    }
    
    public init(color: (red: Double, green: Double, blue: Double, alpha: Double)) {
        
        self.internalPointer = cairo_pattern_create_rgba(color.red, color.green, color.blue, color.alpha)
    }
    
    public init(linear: (origin: (x: Double, y: Double), destination: (x: Double, y: Double))) {
        
        self.internalPointer = cairo_pattern_create_linear(linear.origin.x, linear.origin.y, linear.destination.x, linear.destination.y)
    }
    
    public init(radial: (start: (center: (x: Double, y: Double), radius: Double), end: (center: (x: Double, y: Double), radius: Double))) {
        
        self.internalPointer = cairo_pattern_create_radial(radial.start.center.x, radial.start.center.y, radial.start.radius, radial.end.center.x, radial.end.center.y, radial.end.radius)
    }
    
    public static var mesh: Pattern {
        
        let internalPointer = cairo_pattern_create_mesh()!
        
        return self.init(internalPointer)
    }
    
    // MARK: - Accessors
    
    public var type: PatternType {
        
        let internalPattern = cairo_pattern_get_type(internalPointer)
        
        let pattern = PatternType(rawValue: internalPattern.rawValue)!
        
        return pattern
    }
    
    public var status: Status {
        
        return cairo_pattern_status(internalPointer)
    }
    
    public var matrix: Matrix {
        
        get {
            
            var matrix = Matrix()
            
            cairo_pattern_get_matrix(internalPointer, &matrix)
            
            return matrix
        }
        
        set {
            
            var newValue = newValue
            
            cairo_pattern_set_matrix(internalPointer, &newValue)
        }
    }
    
    public var extend: Extend {
        
        get { return Extend(rawValue: cairo_pattern_get_extend(internalPointer).rawValue)!  }
        
        set { cairo_pattern_set_extend(internalPointer, cairo_extend_t(rawValue: newValue.rawValue)) }
    }
    
    // MARK: - Methods
    
    public func withUnsafePointer<R, E>(_ body: (OpaquePointer) throws(E) -> R) throws(E) -> R where E: Error {
        try body(internalPointer)
    }
    
    /// Adds an opaque color stop to a gradient pattern.
    public func addColorStop(_ offset: Double, red: Double, green: Double, blue: Double) {
        
        cairo_pattern_add_color_stop_rgb(internalPointer, offset, red, green, blue)
    }
    
    /// Adds an opaque color stop to a gradient pattern.
    public func addColorStop(_ offset: Double, red: Double, green: Double, blue: Double, alpha: Double) {
        
        cairo_pattern_add_color_stop_rgba(internalPointer, offset, red, green, blue, alpha)
    }
}


// MARK: - Supporting Types

/// Subtypes of `Pattern`
public enum PatternType: UInt32 {
    
    case solid, surface, linear, radial, mesh, rasterSource
}

public enum Extend: UInt32 {
    
    case none, `repeat`, reflect, pad
}

