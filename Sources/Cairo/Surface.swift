//
//  Surface.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 1/31/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import CCairo

public final class Surface {
    
    // MARK: - Internal Properties
    
    internal var internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        
        cairo_surface_destroy(internalPointer)
    }
    
    internal init(_ internalPointer: OpaquePointer) {
                
        self.internalPointer = internalPointer
    }
    
    public convenience init(format: ImageFormat, width: Int, height: Int) {
        
        let internalFormat = cairo_format_t(rawValue: format.rawValue)
        
        let pointer = cairo_image_surface_create(internalFormat, Int32(width), Int32(height))
        
        self.init(pointer)
    }
    
    // MARK: - Methods
    
    public func flush() {
        
        cairo_surface_flush(internalPointer)
    }
    
    public func markDirty() {
        
        cairo_surface_mark_dirty(internalPointer)
    }
    
    // MARK: - Accessors
    
    public var type: SurfaceType {
        
        let value = cairo_surface_get_type(internalPointer)
        
        guard let surfaceType = SurfaceType(rawValue: value.rawValue)
            else { fatalError("Invalid surface type: \(value)") }
        
        return surfaceType
    }
    
    
}
