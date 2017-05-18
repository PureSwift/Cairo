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
    
    public init(_ internalPointer: OpaquePointer) {
        
        self.internalPointer = internalPointer
    }
    
    public init(format: ImageFormat, width: Int, height: Int) {
        
        let internalFormat = cairo_format_t(rawValue: format.rawValue)
        
        self.internalPointer = cairo_image_surface_create(internalFormat, Int32(width), Int32(height))
    }
    
    public init(svg filename: String, width: Double, height: Double) {
        
        self.internalPointer = cairo_svg_surface_create(filename, width, height)
    }
    
    public init(pdf filename: String, width: Double, height: Double) {
        
        self.internalPointer = cairo_pdf_surface_create(filename, width, height)
    }
    
    // MARK: - Methods
    
    public func flush() {
        
        cairo_surface_flush(internalPointer)
    }
    
    public func markDirty() {
        
        cairo_surface_mark_dirty(internalPointer)
    }
    
    public func writePNG(to filepath: String) {
        
        cairo_surface_write_to_png(internalPointer, filepath)
    }
    
    // MARK: - Accessors
    
    public var type: SurfaceType {
        
        let value = cairo_surface_get_type(internalPointer)
        
        guard let surfaceType = SurfaceType(rawValue: value.rawValue)
            else { fatalError("Invalid surface type: \(value)") }
        
        return surfaceType
    }
}
