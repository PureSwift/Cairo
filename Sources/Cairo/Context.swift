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
    
    deinit {
     
        cairo_destroy(internalPointer)
    }
    
    /// Creates a new `Context` with all graphics state parameters set to default values 
    /// and with `surface` as a target surface.
    public init(surface: Surface) {
        
        // create
        let internalPointer = cairo_create(surface.internalPointer)
        
        assert(internalPointer != nil, "Could not create internal pointer")
        
        // set values
        self.internalPointer = internalPointer
        self.surface = surface
    }
    
    // MARK: - Methods
    
    /// Makes a copy of the current state of the context and saves it on an internal stack of saved states.
    /// When `restore()` is called, the context will be restored to the saved state.
    /// Multiple calls to `save()` and `restore()` can be nested; 
    /// each call to `restore()` restores the state from the matching paired cairo_save().
    public func save() {
        
        cairo_save(internalPointer)
    }
    
    /// Restores the context to the state saved by a preceding call to `save()` and removes that state from the stack of saved states.
    public func restore() {
        
        cairo_restore(internalPointer)
    }
    
    public func pushGroup(content: Content? = nil) {
        
        if let content = content {
            
            cairo_push_group_with_content(internalPointer, cairo_content_t(rawValue: content.rawValue))
            
        } else {
            
            cairo_push_group(internalPointer)
        }
    }
    
    // MARK: - Accessors
    
    
    
}