//
//  SurfaceType.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 2/1/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import CCairo

/// Used to describe the type of a given surface.
/// The surface types are also known as "backends" or "surface backends" within cairo.
public enum SurfaceType: UInt32 {
    
    case image
    case pdf
    case ps
    case xlib
    case xcb
    case glitz
    case quartz
    case win32
    case beos
    case directFB
    case svg
    case os2
    case win32Printing
    case quartzImage
    case script
    case qt
    case recording
    case openVG
    case openGL
    case drm
    case tee
    case xml
    case skia
    case subsurface
    case cogl
}

public extension SurfaceType {
    
    init(_ surfaceType: cairo_surface_type_t) {
        
        self.init(rawValue: surfaceType.rawValue)!
    }
}

public extension cairo_surface_type_t {
    
    init(_ surfaceType: SurfaceType) {
        
        self.init(surfaceType.rawValue)
    }
}
