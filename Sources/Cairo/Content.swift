//
//  Content.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 2/1/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

/// Used to describe the content that a surface will contain, whether color information, 
/// alpha information (translucence vs. opacity), or both.
public enum Content: UInt32 {
    
    /// The surface will hold color content only.
    case Color          = 0x1000
    
    /// The surface will hold alpha content only.
    case Alpha          = 0x2000
    
    /// The surface will hold color and alpha content.
    case ColorAlpha     = 0x3000
}
