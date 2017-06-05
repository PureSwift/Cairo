//
//  SVGSurface.swift
//  Silica
//
//  Created by Alsey Coleman Miller on 6/3/17.
//
//

import CCairo

public extension Surface {
    
    public final class SVG: Surface {
        
        // MARK: - Initialization
        
        public init(filename: String, width: Double, height: Double) {
            
            self.internalPointer = cairo_svg_surface_create(filename, width, height)
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
