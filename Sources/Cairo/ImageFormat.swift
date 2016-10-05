//
//  ImageFormat.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 1/31/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

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
