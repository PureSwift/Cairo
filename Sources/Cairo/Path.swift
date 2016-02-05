//
//  Path.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 2/4/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import CCairo

public final class Path {
    
    // MARK: - Internal Properties
    
    internal let internalPointer: UnsafeMutablePointer<cairo_path_t>
    
    // MARK: - Initialization
    
    deinit {
        
        cairo_path_destroy(internalPointer)
    }
    
    internal init(_ internalPointer: UnsafeMutablePointer<cairo_path_t>) {
        
        assert(internalPointer != nil)
        
        self.internalPointer = internalPointer
    }
}
