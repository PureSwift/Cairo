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
    
    /// Temporarily redirects drawing to an intermediate surface known as a group. 
    /// The redirection lasts until the group is completed by a call to `popGroup()`.
    /// These calls provide the result of any drawing to the group as a pattern, 
    /// (either as an explicit object, or set as the source pattern).
    ///
    /// This group functionality can be convenient for performing intermediate compositing. 
    /// One common use of a group is to render objects as opaque within the group, 
    /// (so that they occlude each other), and then blend the result with translucence onto the destination.
    public func pushGroup(content: Content? = nil) {
        
        if let content = content {
            
            cairo_push_group_with_content(internalPointer, cairo_content_t(rawValue: content.rawValue))
            
        } else {
            
            cairo_push_group(internalPointer)
        }
    }
    
    /// Terminates the redirection begun by a call to `pushGroup()` and 
    /// returns a new pattern containing the results of all drawing operations performed to the group.
    public func popGroup() -> Pattern {
        
        let patternPointer = cairo_pop_group(internalPointer)
        
        let pattern = Pattern(patternPointer)
        
        return pattern
    }
    
    /// Terminates the redirection begun by a call to `pushGroup()` 
    /// and installs the resulting pattern as the source pattern in the given context.
    public func popGroupToSource() {
        
        cairo_pop_group_to_source(internalPointer)
    }
    
    public func setSourceColor(red: Double, green: Double, blue: Double) {
        
        cairo_set_source_rgb(internalPointer, red, green, blue)
    }
    
    // MARK: - Accessors
    
    /// Gets the current destination surface for the context. 
    ///
    /// This is either the original target surface or the target surface for the current group 
    /// as started by the most recent call to `pushGroup()`.
    public var groupTarget: Surface {
        
        let surfacePointer = cairo_get_group_target(internalPointer)
        
        let surface = Surface(surfacePointer)
        
        return surface
    }
    
    
    
}

