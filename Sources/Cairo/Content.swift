//
//  Content.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 2/1/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import struct CCairo.cairo_content_t

/// Used to describe the content that a surface will contain, whether color information, 
/// alpha information (translucence vs. opacity), or both.
public enum Content: UInt32 {
    
    /// The surface will hold color content only.
    case color          = 0x1000
    
    /// The surface will hold alpha content only.
    case alpha          = 0x2000
    
    /// The surface will hold color and alpha content.
    case colorAlpha     = 0x3000
}

// MARK: - Cairo Extensions

public extension Content {
    
    @inline(__always)
    init(_ content: cairo_content_t) {
        self.init(rawValue: content.rawValue)!
    }
}

public extension cairo_content_t {
    
    @inline(__always)
    init(_ content: Content) {
        self.init(content.rawValue)
    }
}
