//
//  Font.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 5/7/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import CCairo
import CFreeType

public final class ScaledFont {
    
    // MARK: - Properties
    
    internal let internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        cairo_scaled_font_destroy(internalPointer)
    }
    
    internal init(_ internalPointer: OpaquePointer) {
        self.internalPointer = internalPointer
    }
    
    public init(
        face: FontFace,
        matrix: Matrix,
        currentTransformation: Matrix,
        options: FontOptions
    ) throws(CairoError) {
        var matrixCopy = (matrix, currentTransformation)
        self.internalPointer = cairo_scaled_font_create(face.internalPointer, &matrixCopy.0, &matrixCopy.1, options.internalPointer)!
        try self.status.throwsError()
    }
    
    // MARK: - Accessors
    
    public var status: Status {
        return cairo_scaled_font_status(internalPointer)
    }
    
    public var type: FontType {
        FontType(cairo_scaled_font_get_type(internalPointer))
    }
    
    public lazy var face: FontFace = {
        let pointer = cairo_scaled_font_get_font_face(internalPointer)!
        cairo_font_face_reference(pointer)
        return FontFace(pointer)
    }()
    
    /// same as `maximumAdvancement`
    public var fontExtents: cairo_font_extents_t {
        var fontExtents = cairo_font_extents_t()
        cairo_scaled_font_extents(internalPointer, &fontExtents)
        return fontExtents
    }
    
    // MARK: FreeType Properties
    
    public lazy var fullName: String = {
        return self.lockFontFace { String(validatingCString: $0.pointee.family_name)! }
    }()
    
    public lazy var postScriptName: String? = {
        
        return self.lockFontFace {
            
            if let cString = FT_Get_Postscript_Name($0) {
                
                return String(cString: cString)
                
            } else {
                
                return nil
            }
        }
    }()
    
    public lazy var ascent: Int = {
        
        return self.lockFontFace { $0.pointee.bbox.yMax }
    }()
    
    public lazy var capHeight: Int = {
        
        return self.lockFontFace {
            
            if let tablePointer = FT_Get_Sfnt_Table($0, FT_SFNT_OS2) {
                
                // owned by font face
                let os2Table = tablePointer.assumingMemoryBound(to: TT_OS2.self)
                
                return Int(os2Table.pointee.sCapHeight)
                
            } else {
                
                return 0
            }
        }
    }()
    
    public lazy var descent: Int = {
        
        return self.lockFontFace { Int($0.pointee.descender) }
    }()
    
    public lazy var fontBBox: (x: Int, y: Int, width: Int, height: Int) = {
        
        return self.lockFontFace {
            
            let bbox = $0.pointee.bbox
            
            return (bbox.xMin, bbox.yMin, bbox.xMax - bbox.xMin, bbox.yMax - bbox.yMin)
        }
    }()
    
    public lazy var italicAngle: Double = {
        
        return self.lockFontFace {
            
            if let tablePointer = FT_Get_Sfnt_Table($0, FT_SFNT_POST) {
                
                // owned by font face
                let psTable = tablePointer.assumingMemoryBound(to: TT_Postscript.self)
                
                return Double(psTable.pointee.italicAngle)
                
            } else {
                
                return 0
            }
        }
    }()
    
    public lazy var leading: Int = {
        
        return self.lockFontFace { Int($0.pointee.height + $0.pointee.ascender + $0.pointee.descender) }
    }()
    
    public lazy var glyphCount: Int = {
        
        return self.lockFontFace { Int($0.pointee.num_glyphs) }
    }()
    
    public lazy var unitsPerEm: Int = {
        
        return self.lockFontFace { Int($0.pointee.units_per_EM) }
    }()
    
    public lazy var xHeight: Int = {
        
        return self.lockFontFace {
            
            if let tablePointer = FT_Get_Sfnt_Table($0, FT_SFNT_OS2) {
                
                // owned by font face
                let os2Table = tablePointer.assumingMemoryBound(to: TT_OS2.self)
                
                return Int(os2Table.pointee.sxHeight)
                
            } else {
                
                return 0
            }
        }
    }()
    
    // MARK: - Subscripting
    
    public subscript (glyph: FontIndex) -> String {
        
        return self.lockFontFace { (fontFace) in
            
            let bufferSize = 256
            let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: bufferSize)
            defer { buffer.deallocate() }
            
            FT_Get_Glyph_Name(fontFace, FT_UInt(glyph), buffer, FT_UInt(bufferSize))
            
            return String(validatingCString: buffer)!
        }
    }
    
    public subscript (glyphName: String) -> FontIndex {
        
        return self.lockFontFace { (fontFace) in
            
            return glyphName.withCString { (cString) in
                
                return FontIndex(FT_Get_Name_Index(fontFace, UnsafeMutablePointer(mutating: cString)))
            }
        }
    }
    
    public subscript (character: UInt) -> FontIndex {
        
        return self.lockFontFace { FontIndex(FT_Get_Char_Index($0, character)) }
    }
    
    // MARK: - Methods
    
    public func withUnsafePointer<R, E>(_ body: (OpaquePointer) throws(E) -> R) throws(E) -> R where E: Error {
        try body(internalPointer)
    }
    
    public func advances(for glyphs: [FontIndex]) -> [Int] {
        
        return self.lockFontFace { (fontFace) in
            
            return glyphs.map { (glyph) in
                
                FT_Load_Glyph(fontFace, FT_UInt(glyph), Int32(FT_LOAD_NO_SCALE))
                
                return fontFace.pointee.glyph.pointee.metrics.horiAdvance
            }
        }
    }
    
    public func boundingBoxes(for glyphs: [FontIndex]) -> [(x: Int, y: Int, width: Int, height: Int)] {
        
        return self.lockFontFace { (fontFace) in
            
            return glyphs.map { (glyph) in
                
                FT_Load_Glyph(fontFace, FT_UInt(glyph), Int32(FT_LOAD_NO_SCALE))
                
                let metrics = fontFace.pointee.glyph.pointee.metrics
                
                return (metrics.horiBearingX, metrics.horiBearingY - metrics.height, metrics.width, metrics.height)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func lockFontFace<T>(_ block: (FT_Face) -> T) -> T {
        
        let ftFace = cairo_ft_scaled_font_lock_face(self.internalPointer)!
        
        defer { cairo_ft_scaled_font_unlock_face(self.internalPointer) }
        
        return block(ftFace)
    }
}

// MARK: - Supporting Types

public typealias FontIndex = UInt16

/// The font's face.
///
/// - Note: Only compatible with FreeType and FontConfig.
public final class FontFace {
    
    // MARK: - Properties
    
    internal let internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        cairo_font_face_destroy(internalPointer)
    }
    
    public init(fontConfigPattern: OpaquePointer) {
        self.internalPointer = cairo_ft_font_face_create_for_pattern(fontConfigPattern)!
    }
    
    internal init(_ internalPointer: OpaquePointer) {
        self.internalPointer = internalPointer
    }
    
    // MARK: - Accessors
    
    public var status: Status {
        return cairo_font_face_status(internalPointer)
    }
    
    public var type: cairo_font_type_t {
        cairo_font_face_get_type(internalPointer) // Never changes
    }
    
    // MARK: - Methods
    
    public func withUnsafePointer<R, E>(_ body: (OpaquePointer) throws(E) -> R) throws(E) -> R where E: Error {
        try body(internalPointer)
    }
}

public final class FontOptions {
    
    // MARK: - Properties
    
    internal let internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        
        cairo_font_options_destroy(internalPointer)
    }
    
    internal init(_ internalPointer: OpaquePointer) {
        
        self.internalPointer = internalPointer
    }
    
    /// Initializes a new `FontOptions` object.
    public init() {
        
        self.internalPointer = cairo_font_options_create()!
    }
    
    // MARK: - Methods
    
    public func withUnsafePointer<R, E>(_ body: (OpaquePointer) throws(E) -> R) throws(E) -> R where E: Error {
        try body(internalPointer)
    }
    
    public func merge(_ other: FontOptions) {
        
        cairo_font_options_merge(internalPointer, other.internalPointer)
    }
    
    // MARK: - Accessors
    
    public var status: Status {
        
        return cairo_font_options_status(internalPointer)
    }
    
    public var copy: FontOptions {
        
        return FontOptions(cairo_font_options_copy(internalPointer))
    }
    
    public var hintMetrics: FontHintMetrics {
        
        get { return FontHintMetrics(rawValue: cairo_font_options_get_hint_metrics(internalPointer).rawValue)! }
        
        set { cairo_font_options_set_hint_metrics(internalPointer, cairo_hint_metrics_t(rawValue: newValue.rawValue)) }
    }
    
    public var hintStyle: cairo_hint_style_t {
        
        get { return cairo_font_options_get_hint_style(internalPointer) }
        
        set { cairo_font_options_set_hint_style(internalPointer, newValue) }
    }
    
    public var antialias: cairo_antialias_t {
        
        get { return cairo_font_options_get_antialias(internalPointer) }
        
        set { cairo_font_options_set_antialias(internalPointer, newValue) }
    }
    
    public var subpixelOrder: cairo_subpixel_order_t {
        
        get { return cairo_font_options_get_subpixel_order(internalPointer) }
        
        set { cairo_font_options_set_subpixel_order(internalPointer, newValue) }
    }
}

extension FontOptions: Equatable {
    
    public static func == (lhs: FontOptions, rhs: FontOptions) -> Bool {
        return cairo_font_options_equal(lhs.internalPointer, rhs.internalPointer) != 0
    }
}

extension FontOptions: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        let hashValue = cairo_font_options_hash(internalPointer)
        hashValue.hash(into: &hasher)
    }
}

// MARK: - Supporting Types

/// cairo_font_slant_t
public enum FontSlant: UInt32 {
    
    case normal
    case italic
    case oblique
}

/// cairo_font_weight_t
public enum FontWeight: UInt32 {
    
    case normal
    case bold
}

/// cairo_hint_metrics_t
public enum FontHintMetrics: UInt32 {
    
    case `default`
    case off
    case on
}

/// cairo_font_type_t
public enum FontType: UInt32 {
    
    case toy
    case ft
    case win32
    case quartz
    case user
    case dwrite
}

internal extension FontType {
    
    init(_ cairo: cairo_font_type_t) {
        self.init(rawValue: cairo.rawValue)!
    }
}

#if os(Linux)
public let FT_SFNT_OS2 = FT_Sfnt_Tag(rawValue: 2)
public let FT_SFNT_POST = FT_Sfnt_Tag(rawValue: 5)
#endif
