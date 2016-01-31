//
//  Context.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 1/31/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import CCairo

/// Cairo Context
public final class Context {
    
    // MARK: - Properties
    
    public let surface: Surface
    
    // MARK: - Internal Properties
    
    internal var internalPointer: COpaquePointer
    
    // MARK: - Initialization
    
    public init(surface: Surface) {
        
        // create
        let internalPointer = cairo_create(surface.internalPointer)
        
        assert(internalPointer != nil, "Could not create internal pointer")
        
        // set values
        self.internalPointer = internalPointer
        self.surface = surface
    }
}