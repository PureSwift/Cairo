//
//  ImageFormat.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 1/31/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import struct CCairo.cairo_format_t
import func CCairo.cairo_format_stride_for_width

/// Used to identify the memory format of image data.
public enum ImageFormat: CInt {
    
    /// Each pixel is a 32-bit quantity, with
    /// alpha in the upper 8 bits, then red, then green, then blue.
    /// The 32-bit quantities are stored native-endian. Pre-multiplied alpha is used. 
    /// (That is, 50% transparent red is 0x80800000, not 0x80ff0000.)
    case argb32 = 0
    
    case rgb24
    
    case a8
    
    case a1
    
    case rgb16565
    
    case rgb30
}

// MARK: - Cairo Extensions

public extension ImageFormat {
    
    @inline(__always)
    init?(_ format: cairo_format_t) {
        
        self.init(rawValue: format.rawValue)
    }
    
    /// Provides stride value that will respect all alignment requirements of the accelerated image-rendering code within Cairo.
    @inline(__always)
    func stride(for width: Int) -> Int {
        
        return Int(cairo_format_stride_for_width(cairo_format_t(self), Int32(width)))
    }
}

public extension cairo_format_t {
    
    @inline(__always)
    init(_ imageFormat: ImageFormat) {
        
        self.init(imageFormat.rawValue)
    }
}
