//
//  SVGSurface.swift
//  Silica
//
//  Created by Alsey Coleman Miller on 6/3/17.
//
//

import CCairo

public extension Surface {
    
    final class SVG: Surface {
        
        // MARK: - Initialization
        
        public init(filename: String, width: Double, height: Double) throws {
            
            let internalPointer = cairo_svg_surface_create(filename, width, height)!
            
            try super.init(internalPointer)
        }
        
        // MARK: - Class Methods
        
        public override class func isCompatible(with surfaceType: SurfaceType) -> Bool {
            
            switch surfaceType {
                
            case .svg: return true
            default: return false
            }
        }
    }
}
