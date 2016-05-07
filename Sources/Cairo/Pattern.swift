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
    
    // MARK: - Internal Properties
    
    internal var internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        
        cairo_pattern_destroy(internalPointer)
    }
    
    internal init(_ internalPointer: OpaquePointer) {
        
        self.internalPointer = internalPointer
    }
    
    public convenience init(surface: Surface) {
        
        let internalPointer = cairo_pattern_create_for_surface(surface.internalPointer)
        
        self.init(internalPointer)
    }
    
    public convenience init(linear: ((Double, Double), (Double, Double))) {
        
        let internalPointer = cairo_pattern_create_linear(linear.0.0, linear.0.1, linear.1.0, linear.1.1)
        
        self.init(internalPointer)
    }
    
    public static var mesh: Pattern {
        
        let internalPointer = cairo_pattern_create_mesh()
        
        return self.init(internalPointer)
    }
    
    // MARK: - Accessors
    
    public var type: PatternType {
        
        let internalPattern = cairo_pattern_get_type(internalPointer)
        
        let pattern = PatternType(rawValue: internalPattern.rawValue)!
        
        return pattern
    }
}


// MARK: - Supporting Types

/// Subtypes of `Pattern`
public enum PatternType: UInt32 {
    
    case Solid, Surface, Linear, Radial, Mesh, RasterSource
}

