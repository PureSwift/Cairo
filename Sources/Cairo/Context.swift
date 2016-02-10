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
    
    public func setSourceColor(red red: Double, green: Double, blue: Double) {
        
        cairo_set_source_rgb(internalPointer, red, green, blue)
    }
    
    public func setSourceColor(red red: Double, green: Double, blue: Double, alpha: Double) {
        
        cairo_set_source_rgba(internalPointer, red, green, blue, alpha)
    }
    
    public func stroke() {
        
        cairo_stroke(internalPointer)
    }
    
    public func fill() {
        
        cairo_fill(internalPointer)
    }
    
    public func paint(alpha: Double? = nil) {
        
        if let alpha = alpha {
            
            cairo_paint_with_alpha(internalPointer, alpha)
        }
        else {
            
            cairo_paint(internalPointer)
        }
    }
    
    /// Adds a closed sub-path rectangle of the given size to the current path at position (x , y ) in user-space coordinates.
    public func addRectangle(x x: Double, y: Double, width: Double, height: Double) {
        
        cairo_rectangle(internalPointer, x, y, width, height)
    }
    
    /// Adds a circular arc of the given radius to the current path. 
    /// The arc is centered at (xc , yc ), begins at angle1 and proceeds in the direction of increasing angles to end at
    /// angle2 . If angle2 is less than angle1 it will be progressively increased by 2*M_PI until it is greater than angle1 .
    ///
    /// If there is a current point, an initial line segment will be added to the path to connect the current point to
    /// the beginning of the arc. If this initial line is undesired, it can be avoided by calling `newSubpath()` before calling `addArc()`.
    ///
    /// Angles are measured in radians. 
    /// An angle of `0.0` is in the direction of the positive X axis (in user space).
    /// An angle of `M_PI/2.0` radians (90 degrees) is in the direction of the positive Y axis (in user space).
    /// Angles increase in the direction from the positive X axis toward the positive Y axis. 
    /// So with the default transformation matrix, angles increase in a clockwise direction.
    ///
    /// (To convert from degrees to radians, use `degrees * (M_PI / 180.)`.)
    ///
    /// This method gives the arc in the direction of increasing angles; see `arcNegative()`
    /// to get the arc in the direction of decreasing angles.
    public func addArc(center: (x: Double, y: Double), radius: Double, angle: (Double, Double), negative: Bool = false) {
        
        if negative {
            
            cairo_arc_negative(internalPointer, center.x, center.y, radius, angle.0, angle.1)
            
        } else {
            
            cairo_arc(internalPointer, center.x, center.y, radius, angle.0, angle.1)
        }
    }
    
    /// Creates a copy of the current path and returns it to the user as a `Path`.
    public func copyPath() -> Path {
        
        let pathPointer = cairo_copy_path(internalPointer)
        
        return Path(pathPointer)
    }
    
    /// Gets a flattened copy of the current path.
    public func copyFlatPath() -> Path {
        
        let pathPointer = cairo_copy_path_flat(internalPointer)
        
        return Path(pathPointer)
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
    
    public var lineWidth: Double {
        
        get { return cairo_get_line_width(internalPointer) }
        
        set { cairo_set_line_width(internalPointer, newValue) }
    }
    
    
}

