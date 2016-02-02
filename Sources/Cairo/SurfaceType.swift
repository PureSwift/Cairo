//
//  SurfaceType.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 2/1/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

/// Used to describe the type of a given surface.
/// The surface types are also known as "backends" or "surface backends" within cairo.
public enum SurfaceType: UInt32 {
    
    case Image
    case PDF
    case PS
    case XLib
    case XCB
    case Glitz
    case Quartz
    case Win32
    case BEOS
    case DirectFB
    case SVG
    case OS2
    case Win32Printing
    case QuartzImage
    case Script
    case QT
    case Recording
    case OpenVG
    case OpenGL
    case DRM
    case Tee
    case XML
    case Skia
    case Subsurface
    case COGL
}