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
        
        self.internalPointer = internalPointer
    }
    
    // MARK: - Properties
    
    public var count: Int {
        
        return Int(internalPointer.pointee.num_data)
    }
    
    public var status: Status {
        
        return internalPointer.pointee.status
    }
    
    public lazy var data: [cairo_path_data_t] = {
        
        var data = [cairo_path_data_t](repeating: cairo_path_data_t(), count: self.count)
        
        for index in 0 ..< self.count {
            
            data[index] = self.internalPointer.pointee.data[index]
        }
        
        return data
    }()
    
    // MARK: - Methods
    
    public subscript (index: Int) -> cairo_path_data_t {
        
        return internalPointer.pointee.data[index]
    }
}
