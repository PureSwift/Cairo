//
//  SurfacePNG.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 6/5/17.
//
//

import struct Foundation.Data
import CCairo

public extension Surface {
    
    /// Writes the surface's contents to a PNG file.
    public func writePNG(atPath path: String) {
        
        cairo_surface_write_to_png(internalPointer, path)
    }
}

public extension Surface.Image {
    
    /// Creates a new image surface from PNG data read incrementally via the read function.
    @inline(__always)
    fileprivate convenience init(png readFunction: @escaping cairo_read_func_t, closure: UnsafeMutableRawPointer) throws {
        
        let internalPointer = cairo_image_surface_create_from_png_stream(readFunction, closure)!
        
        try self.init(internalPointer)
    }
    
    convenience init(png data: Data) throws {
        
        let dataProvider = PNGDataProvider(data: data)
        
        let unmanaged = Unmanaged.passUnretained(dataProvider)
        
        let pointer = unmanaged.toOpaque()
        
        try self.init(png: pngRead, closure: pointer)
    }
}

// MARK: - Supporting Types

fileprivate extension Surface.Image {
    
    final class PNGDataProvider {
        
        let data: Data
        private(set) var position: Int
        
        init(data: Data) {
            self.data = data
            self.position = 0
        }
        
        @inline(__always)
        func copyBytes(to pointer: UnsafeMutablePointer<UInt8>, length: Int) -> cairo_status_t {
            
            var size = length
            
            if (position + size) > data.count {
                
                size = data.count - position;
            }
            
            let byteRange = Range<Data.Index>(position ..< position + size)
            
            let _ = data.copyBytes(to: pointer, from: byteRange)
            
            position += size
            
            return CAIRO_STATUS_SUCCESS
        }
    }
}

// MARK: - Private Functions

@_silgen_name("_cairo_swift_png_read_data")
private func pngRead(_ closure: UnsafeMutableRawPointer?, _ data: UnsafeMutablePointer<UInt8>?, _ length: UInt32) -> cairo_status_t {
    
    let unmanaged = Unmanaged<Surface.Image.PNGDataProvider>.fromOpaque(closure!)
    
    let dataProvider = unmanaged.takeUnretainedValue()
    
    return dataProvider.copyBytes(to: data!, length: Int(length))
}
