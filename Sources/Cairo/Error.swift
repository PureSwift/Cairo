//
//  Error.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 12/13/24.
//

/// Cairo Error type
public enum CairoError: UInt32, Error {
    
    /// Insufficient memory to perform the operation.
    case noMemory = 1
    
    /// An invalid restore operation, such as restoring a non-existent state.
    case invalidRestore
    
    /// An invalid pop group operation, for example, popping when no group exists.
    case invalidPopGroup
    
    /// No current point has been set.
    case noCurrentPoint
    
    /// An invalid transformation matrix was provided.
    case invalidMatrix
    
    /// The operation failed due to an invalid status code.
    case invalidStatus
    
    /// A null pointer was encountered when performing the operation.
    case nullPointer
    
    /// The provided string is invalid.
    case invalidString
    
    /// The path data provided is invalid.
    case invalidPathData
    
    /// An error occurred while reading data.
    case read
    
    /// An error occurred while writing data.
    case write
    
    /// The surface is already finished and cannot be used further.
    case surfaceFinished
    
    /// The surface type does not match the expected type.
    case surfaceTypeMismatch
    
    /// The pattern type does not match the expected type.
    case patternTypeMismatch
    
    /// The specified content is invalid for the operation.
    case invalidContent
    
    /// The format of the data is invalid or unsupported.
    case invalidFormat
    
    /// The visual provided is invalid.
    case invalidVisual
    
    /// The specified file could not be found.
    case fileNotFound
    
    /// The dash pattern is invalid.
    case invalidDash
    
    /// The DSC (Document Structuring Conventions) comment is invalid.
    case invalidDscComment
    
    /// The index provided is invalid.
    case invalidIndex
    
    /// The clipping path is not representable in the current context.
    case clipNotRepresentable
    
    /// An error occurred while handling a temporary file.
    case tempFile
    
    /// The stride (row size) for a surface is invalid.
    case invalidStride
    
    /// The font type provided is invalid for the operation.
    case fontTypeMismatch
    
    /// The user font is immutable and cannot be changed.
    case userFontImmutable
    
    /// A general error occurred with a user font.
    case userFont
    
    /// A negative count value was provided where a non-negative count was expected.
    case negativeCount
    
    /// The clusters provided are invalid.
    case invalidClusters
    
    /// The slant value for the font is invalid.
    case invalidSlant
    
    /// The weight value for the font is invalid.
    case invalidWeight
    
    /// The font size is invalid.
    case invalidSize
    
    /// The user font implementation is missing or incomplete.
    case userFontNotImplemented
    
    /// The device type is incorrect for the operation.
    case deviceTypeMismatch
    
    /// A general error occurred with the device.
    case device
    
    /// There was an error constructing the mesh.
    case invalidMeshConstruction
    
    /// The device has been finished and cannot be used further.
    case deviceFinished
    
    /// Required global JBIG2 data is missing.
    case jbig2GlobalMissing
    
    /// An error occurred while reading or writing PNG data.
    case png
    
    /// A FreeType error occurred, typically related to font rendering.
    case freetype
    
    /// A GDI error occurred on Windows (Win32).
    case win32Gdi
    
    /// There was an error with the tag in the operation.
    case tag
    
    /// A DirectWrite (DWrite) error occurred.
    case dwrite
    
    /// An error occurred with the SVG font.
    case svgFont
}

public extension CairoError {
    
    init?(_ status: Cairo.Status) {
        self.init(rawValue: status.rawValue)
    }
}

// MARK: - CustomStringConvertible

extension CairoError: CustomStringConvertible {
    
    public var description: String {
        Cairo.Status(rawValue: self.rawValue).description
    }
}
