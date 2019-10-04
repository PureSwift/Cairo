//
//  Path.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 2/4/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import CCairo

public final class Path {
    
    // MARK: - Properties
    
    public let pointer: UnsafeMutablePointer<cairo_path_t>
    
    // MARK: - Initialization
    
    deinit {
        
        cairo_path_destroy(pointer)
    }
    
    internal init(_ pointer: UnsafeMutablePointer<cairo_path_t>) {
        
        self.pointer = pointer
    }
    
    // MARK: - Properties
    
    public var count: Int {
        
        return Int(pointer.pointee.num_data)
    }
    
    public var status: Status {
        
        return pointer.pointee.status
    }
    
    public lazy var data: [cairo_path_data_t] = {
        
        var data = [cairo_path_data_t](repeating: cairo_path_data_t(), count: self.count)
        
        for index in 0 ..< self.count {
            
            data[index] = self.pointer.pointee.data[index]
        }
        
        return data
    }()
    
    // MARK: - Methods
    
    public subscript (index: Int) -> cairo_path_data_t {
        
        return pointer.pointee.data[index]
    }
}
