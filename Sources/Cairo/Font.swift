//
//  Font.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 5/7/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import CCairo

public enum FontSlant: cairo_font_slant_t.RawValue {
    
    case normal, italic, oblique
}

public enum FontWeight: cairo_font_weight_t.RawValue {
    
    case normal, bold
}