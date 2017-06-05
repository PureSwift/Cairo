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
    
    internal var internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        
        cairo_surface_destroy(internalPointer)
    }
    
    public init(_ internalPointer: OpaquePointer) {
        
        self.internalPointer = internalPointer
    }
    
    public init(similar other: Surface, content: Content, width: Int, height: Int) {
        
        self.internalPointer = cairo_surface_create_similar(other.internalPointer,
                                                            cairo_content_t(content),
                                                            Int32(width), Int32(height))
    }
    
    // MARK: - Methods
    
    /// Do any pending drawing for the surface and also restore any temporary
    /// modifications cairo has made to the surface's state. 
    /// This function must be called before switching from drawing on the surface 
    /// with Cairo to drawing on it directly with native APIs, 
    /// or accessing its memory outside of Cairo. 
    /// If the surface doesn't support direct access, then this function does nothing.
    public func flush() {
        
        cairo_surface_flush(internalPointer)
    }
    
    /// Tells cairo that drawing has been done to surface using means other than cairo, 
    /// and that cairo should reread any cached areas. 
    /// 
    /// - Note: You must `Cairo.Surface.flush()` before doing such drawing.
    public func markDirty() {
        
        cairo_surface_mark_dirty(internalPointer)
    }
    
    /// This function finishes the surface and drops all references to external resources.
    public func finish() {
        
        cairo_surface_finish(internalPointer)
    }
    
    /// Writes the surface's contents to a PNG file.
    public func writePNG(at filepath: String) {
        
        cairo_surface_write_to_png(internalPointer, filepath)
    }
    
    // MARK: - Accessors
    
    public var type: SurfaceType {
        
        return SurfaceType(cairo_surface_get_type(internalPointer))
    }
    
    /// The content type which indicates whether the surface contains color and/or alpha information
    public var content: Content {
        
        return Content(cairo_surface_get_content(internalPointer))
    }
    
    /// Checks whether an error has previously occurred for this surface.
    public var status: Status {
        
        return cairo_surface_status(internalPointer)
    }
}

