//
//  PDFSurface.swift
//  Silica
//
//  Created by Alsey Coleman Miller on 6/3/17.
//
//

import CCairo

public extension Surface {
    
    final class PDF: Surface {
        
        // MARK: - Initialization
        
        public init(filename: String, width: Double, height: Double) throws {
            
            let pointer = cairo_pdf_surface_create(filename, width, height)!
            
            try super.init(pointer)
        }
        
        // MARK: - Class Methods
        
        public override class func isCompatible(with surfaceType: SurfaceType) -> Bool {
            
            switch surfaceType {
                
            case .pdf: return true
            default: return false
            }
        }
    }
}
