//
//  Surface.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 1/31/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import CCairo

public class Surface {
    
    // MARK: - Internal Properties
    
    internal let internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        cairo_surface_destroy(internalPointer)
    }
    
    internal init(_ internalPointer: OpaquePointer) throws(CairoError) {
        // check status
        if let error = CairoError(cairo_surface_status(internalPointer)) {
            cairo_surface_destroy(internalPointer)
            throw error
        }
        self.internalPointer = internalPointer
    }
    
    // MARK: - Class Methods
    
    /// Whether this `Surface` class is compatible with the specified surface type / backend.
    public class func isCompatible(with surfaceType: SurfaceType) -> Bool {
        return true
    }
    
    // MARK: - Methods
    
    public func withUnsafePointer<R, E>(_ body: (OpaquePointer) throws(E) -> R) throws(E) -> R where E: Error {
        try body(internalPointer)
    }
    
    /// Do any pending drawing for the surface and also restore any temporary
    /// modifications cairo has made to the surface's state. 
    /// This function must be called before switching from drawing on the surface 
    /// with Cairo to drawing on it directly with native APIs, 
    /// or accessing its memory outside of Cairo. 
    /// If the surface doesn't support direct access, then this function does nothing.
    public final func flush() {
        cairo_surface_flush(internalPointer)
    }
    
    /// Tells cairo that drawing has been done to surface using means other than cairo, 
    /// and that cairo should reread any cached areas. 
    /// 
    /// - Note: You must `Cairo.Surface.flush()` before doing such drawing.
    public final func markDirty() {
        cairo_surface_mark_dirty(internalPointer)
    }
    
    /// This function finishes the surface and drops all references to external resources.
    public final func finish() {
        cairo_surface_finish(internalPointer)
    }
    
    // MARK: - Accessors
    
    public final var type: SurfaceType {
        return SurfaceType(cairo_surface_get_type(internalPointer))
    }
    
    /// The content type which indicates whether the surface contains color and/or alpha information
    public final var content: Content {
        return Content(cairo_surface_get_content(internalPointer))
    }
    
    /// Checks whether an error has previously occurred for this surface.
    public final var status: Status {
        return cairo_surface_status(internalPointer)
    }
}
