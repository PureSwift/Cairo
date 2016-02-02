//
//  Pattern.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 1/31/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import CCairo

public final class Pattern {
    
    // MARK: - Internal Properties
    
    internal var internalPointer: COpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        
        cairo_pattern_destroy(internalPointer)
    }
    
    internal init(_ internalPointer: COpaquePointer) {
        
        assert(internalPointer != nil, "Internal pointer must not be nil")
        
        self.internalPointer = internalPointer
    }
    
    public convenience init(surface: Surface) {
        
        let internalPointer = cairo_pattern_create_for_surface(surface.internalPointer)
        
        self.init(internalPointer)
    }
}
