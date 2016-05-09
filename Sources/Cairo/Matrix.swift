//
//  Matrix.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 5/8/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import CCairo

public typealias Matrix = cairo_matrix_t

public extension Matrix {
    
    // MARK: - Initialization
    
    static var identity: Matrix {
    
        var matrix = Matrix()
        
        cairo_matrix_init_identity(&matrix)
        
        return matrix
    }
    
    init(scale: (x: Double, y: Double)) {
        
        self.init()
        
        cairo_matrix_init_scale(&self, scale.x, scale.y)
    }
    
    init(rotation radians: Double) {
        
        self.init()
        
        cairo_matrix_rotate(&self, radians)
    }
    
    // MARK: - Methods
    
    /// Applies rotation by radians to the transformation in matrix.
    /// The effect of the new transformation is to first rotate the coordinates by radians,
    /// then apply the original transformation to the coordinates.
    mutating func rotate(_ radians: Double) {
        
        cairo_matrix_rotate(&self, radians)
    }
    
    /// Changes `matrix` to be the inverse of its original value.
    /// Not all transformation matrices have inverses; if the matrix collapses points together (it is degenerate), 
    /// then it has no inverse and this function will fail.
    mutating func inverse() {
        
        cairo_matrix_invert(&self)
    }
    
    mutating func invert() {
        
        cairo_matrix_invert(&self)
    }
    
    /// Multiplies the affine transformations in `a` and `b` together and stores the result in result.
    /// The effect of the resulting transformation is to first apply the transformation in `a` to the coordinates
    /// and then apply the transformation in `b` to the coordinates.
    mutating func multiply(a: Matrix, b: Matrix) {
        
        var copy = (a: a, b: b)
        
        cairo_matrix_multiply(&self, &copy.a, &copy.b)
    }
    
    mutating func scale(x: Double, y: Double) {
        
        cairo_matrix_scale(&self, x, y)
    }
}
