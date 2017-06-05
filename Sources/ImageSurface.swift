//
//  ImageSurface.swift
//  Silica
//
//  Created by Alsey Coleman Miller on 6/3/17.
//
//

import struct Foundation.Data
import CCairo

public extension Surface {
    
    /// Image surfaces provide the ability to render to memory buffers either allocated by cairo or by the calling code.
    /// The supported image formats are those defined in `ImageFormat`.
    public final class Image: Surface {
        
        // MARK: - Initialization
        
        public init(format: ImageFormat, width: Int, height: Int) {
            
            let internalFormat = cairo_format_t(rawValue: format.rawValue)
            
            self.internalPointer = cairo_image_surface_create(internalFormat, Int32(width), Int32(height))
        }
        
        // MARK: - Accessors
        
        public var width: Int {
            
            return Int(cairo_image_surface_get_width(internalPointer))
        }
        
        public var height: Int {
            
            return Int(cairo_image_surface_get_height(internalPointer))
        }
        
        public var stride: Int {
            
            return Int(cairo_image_surface_get_stride(internalPointer))
        }
        
        /// Provides read/write access to the Image Surface data buffer.
        public func withUnsafeMutableBytes<Result>(_ body: (UnsafeMutablePointer<UInt8>) throws -> Result) rethrows -> Result? {
            
            guard let bytes = cairo_image_surface_get_data(internalPointer)
                else { return nil }
            
            return try body(bytes)
        }
        
        /// Get image content `Data`.
        public lazy var data: Data? = {
            
            let internalPointer = self.internalPointer
            
            return self.withUnsafeMutableBytes { (bytes) in
                
                let pointer = UnsafeMutableRawPointer(bytes)
                
                // retain surface pointer so the data can still exist even after Swift object deinit
                cairo_surface_reference(internalPointer)
                
                let deallocator = Data.Deallocator.custom({ _ in cairo_surface_destroy(internalPointer) })
                
                let length = 
                
                return Data(bytesNoCopy: pointer, count: length, deallocator: deallocator)
            }
        }()
    }
}
