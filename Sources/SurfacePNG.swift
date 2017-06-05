//
//  SurfacePNG.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 6/5/17.
//
//

import CCairo

public extension Surface {
    
    /// Writes the surface's contents to a PNG file.
    public func writePNG(at filepath: String) {
        
        cairo_surface_write_to_png(internalPointer, filepath)
    }
}
