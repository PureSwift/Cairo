//
//  Font.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 5/7/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import CCairo
import CFontConfig

public final class FontFace {
    
    // MARK: - Properties
    
    internal let internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        
        cairo_font_face_destroy(internalPointer)
    }
    
    public init(fontConfigPattern: OpaquePointer) {
        
        self.internalPointer = cairo_ft_font_face_create_for_pattern(fontConfigPattern)!
    }
    
    internal init(_ internalPointer: OpaquePointer) {
        
        self.internalPointer = internalPointer
    }
    
    // MARK: - Accessors
    
    public var status: Status {
        
        return cairo_font_face_status(internalPointer)
    }
    
    public lazy var type: cairo_font_type_t = cairo_font_face_get_type(self.internalPointer) // Never changes
}

public final class ScaledFont {
    
    // MARK: - Properties
    
    internal let internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        
        cairo_scaled_font_destroy(internalPointer)
    }
    
    internal init(_ internalPointer: OpaquePointer) {
        
        self.internalPointer = internalPointer
    }
    
    // MARK: - Accessors
    
    public var status: Status {
        
        return cairo_scaled_font_status(internalPointer)
    }
}

// MARK: - Supporting Types

public enum FontSlant: cairo_font_slant_t.RawValue {
    
    case normal, italic, oblique
}

public enum FontWeight: cairo_font_weight_t.RawValue {
    
    case normal, bold
}