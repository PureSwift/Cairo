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
    
    /// Image surfaces provide the ability to render to memory buffers either allocated by Cairo or by the calling code.
    /// The supported image formats are those defined in `ImageFormat`.
    final class Image: Surface {
        
        // MARK: - Initialization
        
        /// Creates an image surface of the specified format and dimensions. 
        ///
        /// Initially the surface contents are all 0. 
        /// Specifically, within each pixel, each color or alpha channel belonging to format will be 0.
        /// The contents of bits within a pixel, but not belonging to the given format are undefined.
        public init(format: ImageFormat, width: Int, height: Int) throws {
            
            let pointer = cairo_image_surface_create(cairo_format_t(format), Int32(width), Int32(height))!
            
            try super.init(pointer)
        }
        
        /// Creates an image surface for the provided pixel data.
        public init(mutableBytes bytes: UnsafeMutablePointer<UInt8>,
                    format: ImageFormat,
                    width: Int,
                    height: Int,
                    stride: Int) throws {
            
            assert(format.stride(for: width) == stride, "Invalid stride")
            
            let pointer = cairo_image_surface_create_for_data(bytes, cairo_format_t(format), Int32(width), Int32(height), Int32(stride))!
            
            try super.init(pointer)
        }
        
        /// Creates an image surface for the provided pixel data.
        static func from <Result> (data: inout Data,
                                   format: ImageFormat,
                                   width: Int,
                                   height: Int,
                                   stride: Int,
                                   body: (Surface.Image) throws -> Result) throws -> Result {
            
            return try data.withUnsafeMutableBytes {
                let surface = try Surface.Image(
                    mutableBytes: $0.baseAddress!.assumingMemoryBound(to: UInt8.self),
                    format: format,
                    width: width,
                    height: height,
                    stride: stride
                )
                return try body(surface)
            }
        }
        
        /// For internal use with extensions (e.g. `init(png:)`)
        internal override init(_ pointer: OpaquePointer) throws {
            
            try super.init(pointer)
        }
                
        // MARK: - Class Methods
        
        public override class func isCompatible(with surfaceType: SurfaceType) -> Bool {
            return surfaceType == .image
        }
        
        // MARK: - Accessors
        
        /// Get the format of the surface.
        public var format: ImageFormat? {
            
            return ImageFormat(cairo_image_surface_get_format(pointer))
        }
        
        /// Get the width of the image surface in pixels.
        public var width: Int {
            
            return Int(cairo_image_surface_get_width(pointer))
        }
        
        /// Get the height of the image surface in pixels.
        public var height: Int {
            
            return Int(cairo_image_surface_get_height(pointer))
        }
        
        /// Get the stride of the image surface in bytes
        public var stride: Int {
            
            return Int(cairo_image_surface_get_stride(pointer))
        }
        
        /// Get a pointer to the data of the image surface, for direct inspection or modification.
        public func withUnsafeMutableBytes<Result>(_ body: (UnsafeMutablePointer<UInt8>) throws -> Result) rethrows -> Result? {
            
            guard let bytes = cairo_image_surface_get_data(pointer)
                else { return nil }
            
            return try body(bytes)
        }
        
        /// Get the immutable data of the image surface.
        public lazy var data: Data? = {
            
            let pointer = self.pointer
            
            let length = self.stride * self.height
            
            return self.withUnsafeMutableBytes { (bytes) in
                
                let bytesPointer = UnsafeMutableRawPointer(bytes)
                
                // retain surface pointer so the data can still exist even after Swift object deinit
                cairo_surface_reference(pointer)
                
                let deallocator = Data.Deallocator.custom({ (_, _) in cairo_surface_destroy(pointer) })
                
                return Data(bytesNoCopy: bytesPointer, count: length, deallocator: deallocator)
            }
        }()
    }
}
