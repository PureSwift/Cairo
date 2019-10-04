//
//  Context.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 1/31/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import CCairo

/// Cairo Context
public final class Context {
    
    // MARK: - Properties
    
    public let surface: Surface

    public let pointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
     
        cairo_destroy(pointer)
    }
    
    /// Creates a new `Context` with all graphics state parameters set to default values 
    /// and with `surface` as a target surface.
    public init(surface: Surface) {
        
        // create
        let pointer = cairo_create(surface.pointer)
        
        assert(pointer != nil, "Could not create internal pointer")
        // set values
        self.pointer = pointer!
        self.surface = surface
    }
    
    // MARK: - Methods
    
    /// Makes a copy of the current state of the context and saves it on an internal stack of saved states.
    /// When `restore()` is called, the context will be restored to the saved state.
    /// Multiple calls to `save()` and `restore()` can be nested; 
    /// each call to `restore()` restores the state from the matching paired `save()`.
    public func save() {
        
        cairo_save(pointer)
    }
    
    /// Restores the context to the state saved by a preceding call to `save()` and removes that state from the stack of saved states.
    public func restore() {
        
        cairo_restore(pointer)
    }
    
    /// Temporarily redirects drawing to an intermediate surface known as a group. 
    /// The redirection lasts until the group is completed by a call to `popGroup()`.
    /// These calls provide the result of any drawing to the group as a pattern, 
    /// (either as an explicit object, or set as the source pattern).
    ///
    /// This group functionality can be convenient for performing intermediate compositing. 
    /// One common use of a group is to render objects as opaque within the group, 
    /// (so that they occlude each other), and then blend the result with translucence onto the destination.
    public func pushGroup(content: Content? = nil) {
        
        if let content = content {
            
            cairo_push_group_with_content(pointer, cairo_content_t(content))
            
        } else {
            
            cairo_push_group(pointer)
        }
    }
    
    /// Terminates the redirection begun by a call to `pushGroup()` and 
    /// returns a new pattern containing the results of all drawing operations performed to the group.
    public func popGroup() -> Pattern {
        
        let patternPointer = cairo_pop_group(pointer)!
        
        let pattern = Pattern(patternPointer)
        
        return pattern
    }
    
    /// Terminates the redirection begun by a call to `pushGroup()` 
    /// and installs the resulting pattern as the source pattern in the given context.
    public func popGroupToSource() {
        
        cairo_pop_group_to_source(pointer)
    }
    
    public func setSource(color: (red: Double, green: Double, blue: Double)) {
        
        cairo_set_source_rgb(pointer, color.red, color.green, color.blue)
    }
    
    public func setSource(color: (red: Double, green: Double, blue: Double, alpha: Double)) {
        
        cairo_set_source_rgba(pointer, color.red, color.green, color.blue, color.alpha)
    }
    
    /// A drawing operator that paints the current source using the alpha channel of surface as a mask. 
    /// 
    /// - Note: Opaque areas of `surface` are painted with the source, transparent areas are not painted.
    public func mask(surface: Surface, at point: (x: Double, y: Double)) {
        
        cairo_mask_surface(pointer, surface.pointer, point.x, point.y)
    }
    
    public func stroke() {
        
        cairo_stroke(pointer)
    }
    
    public func fill() {
        
        cairo_fill(pointer)
    }
    
    public func fillPreserve() {
        
        cairo_fill_preserve(pointer)
    }
    
    public func clip() {
        
        cairo_clip(pointer)
    }
    
    public func clipPreserve() {
        
        cairo_clip_preserve(pointer)
    }
    
    public func paint(alpha: Double? = nil) {
        
        if let alpha = alpha {
            
            cairo_paint_with_alpha(pointer, alpha)
        }
        else {
            
            cairo_paint(pointer)
        }
    }
    
    /// Adds a closed sub-path rectangle of the given size to the current path at position `(x , y)` in user-space coordinates.
    public func addRectangle(x: Double, y: Double, width: Double, height: Double) {
        
        cairo_rectangle(pointer, x, y, width, height)
    }
    
    /// Adds a circular arc of the given radius to the current path. 
    /// The arc is centered at (xc , yc ), begins at angle1 and proceeds in the direction of increasing angles to end at
    /// angle2 . If angle2 is less than angle1 it will be progressively increased by 2*M_PI until it is greater than angle1 .
    ///
    /// If there is a current point, an initial line segment will be added to the path to connect the current point to
    /// the beginning of the arc. If this initial line is undesired, it can be avoided by calling `newSubpath()` before calling `addArc()`.
    ///
    /// Angles are measured in radians. 
    /// An angle of `0.0` is in the direction of the positive X axis (in user space).
    /// An angle of `M_PI/2.0` radians (90 degrees) is in the direction of the positive Y axis (in user space).
    /// Angles increase in the direction from the positive X axis toward the positive Y axis. 
    /// So with the default transformation matrix, angles increase in a clockwise direction.
    ///
    /// (To convert from degrees to radians, use `degrees * (M_PI / 180.)`.)
    ///
    /// This method gives the arc in the direction of increasing angles; see `arcNegative()`
    /// to get the arc in the direction of decreasing angles.
    public func addArc(center: (x: Double, y: Double), radius: Double, angle: (Double, Double), negative: Bool = false) {
        
        if negative {
            
            cairo_arc_negative(pointer, center.x, center.y, radius, angle.0, angle.1)
            
        } else {
            
            cairo_arc(pointer, center.x, center.y, radius, angle.0, angle.1)
        }
    }
    
    /// Creates a copy of the current path and returns it to the user as a `Path`.
    public func copyPath() -> Path {
        
        let pathPointer = cairo_copy_path(pointer)!
        
        return Path(pathPointer)
    }
    
    /// Gets a flattened copy of the current path.
    public func copyFlatPath() -> Path {
        
        let pathPointer = cairo_copy_path_flat(pointer)!
        
        return Path(pathPointer)
    }
    
    public func setFont(size: Double) {
        
        cairo_set_font_size(pointer, size)
    }
    
    public func setFont(face: (family: String, slant: FontSlant, weight: FontWeight)) {
        
        cairo_select_font_face(pointer, face.family, cairo_font_slant_t(face.slant.rawValue), cairo_font_weight_t(face.weight.rawValue))
    }
    
    public func setFont(matrix: Matrix) {
        
        var copy = matrix
        
        cairo_set_font_matrix(pointer, &copy)
    }
    
    public func move(to coordinate: (x: Double, y: Double)) {
        
        cairo_move_to(pointer, coordinate.x, coordinate.y)
    }
    
    public func line(to coordinate: (x: Double, y: Double)) {
        
        cairo_line_to(pointer, coordinate.x, coordinate.y)
    }
    
    public func curve(to controlPoints: (first: (x: Double, y: Double), second: (x: Double, y: Double), end: (x: Double, y: Double))) {
        
        cairo_curve_to(pointer, controlPoints.first.x, controlPoints.first.y, controlPoints.second.x, controlPoints.second.y, controlPoints.end.x, controlPoints.end.y)
    }
    
    public func show(text: String) {
        
        cairo_show_text(pointer, text)
    }
    
    public func show(glyph: cairo_glyph_t) {
        
        var copy = glyph
        
        // due to bug, better to show one at a time
        cairo_show_glyphs(pointer, &copy, 1)
    }
    
    public func scale(x: Double, y: Double) {
        
        cairo_scale(pointer, x, y)
    }
    
    public func translate(x: Double, y: Double) {
        
        cairo_translate(pointer, x, y)
    }
    
    public func rotate(_ angle: Double) {
        
        cairo_rotate(pointer, angle)
    }
    
    public func transform(_ matrix: Matrix) {
        
        var copy = matrix
        
        cairo_transform(pointer, &copy)
    }
    
    public func showPage() {
        
        cairo_show_page(pointer)
    }
    
    public func copyPage() {
        
        cairo_copy_page(pointer)
    }
    
    public func newPath() {
        
        cairo_new_path(pointer)
    }
    
    public func closePath() {
        
        cairo_close_path(pointer)
    }
    
    public func newSubpath() {
        
        cairo_new_sub_path(pointer)
    }
    
    // MARK: - Accessors
    
    public var status: Status {
        
        return cairo_status(pointer)
    }
    
    public var currentPoint: (x: Double, y: Double)? {
        
        guard cairo_has_current_point(pointer) != 0
            else { return nil }
        
        var x: Double = 0
        
        var y: Double = 0
        
        cairo_get_current_point(pointer, &x, &y)
        
        return (x: x, y: y)
    }
    
    public var source: Pattern {
        
        get {
            
            let patternPointer = cairo_get_source(pointer)!
            
            cairo_pattern_reference(patternPointer)
            
            return Pattern(patternPointer)
        }
        
        set {
            
            cairo_set_source(pointer, newValue.pointer)
        }
    }
    
    public var matrix: Matrix {
        
        get {
            
            var matrix = Matrix()
            
            cairo_get_matrix(pointer, &matrix)
            
            return matrix
        }
        
        set {
            
            var copy = newValue
            
            cairo_set_matrix(pointer, &copy)
        }
    }
    
    /// Gets the current destination surface for the context. 
    ///
    /// This is either the original target surface or the target surface for the current group 
    /// as started by the most recent call to `pushGroup()`.
    public var groupTarget: Surface {
        
        let surfacePointer = cairo_get_group_target(pointer)!
        
        let surface = try! Surface(surfacePointer)
        
        return surface
    }
    
    public var fillRule: cairo_fill_rule_t {
        
        get { return cairo_get_fill_rule(pointer) }
        
        set { cairo_set_fill_rule(pointer, newValue) }
    }
    
    public var antialias: cairo_antialias_t {
        
        get { return cairo_get_antialias(pointer) }
        
        set { cairo_set_antialias(pointer, newValue) }
    }
    
    public var lineWidth: Double {
        
        get { return cairo_get_line_width(pointer) }
        
        set { cairo_set_line_width(pointer, newValue) }
    }
    
    public var lineJoin: cairo_line_join_t {
        
        get { return cairo_get_line_join(pointer) }
        
        set { cairo_set_line_join(pointer, newValue) }
    }
    
    public var lineCap: cairo_line_cap_t {
        
        get { return cairo_get_line_cap(pointer) }
        
        set { cairo_set_line_cap(pointer, newValue) }
    }
    
    public var lineDash: (phase: Double, lengths: [Double]) {
        
        get {
            
            var phase: Double = 0
            
            let dashCount = Int(cairo_get_dash_count(pointer))
            
            var lengths = [Double](repeating: 0, count: dashCount)
            
            cairo_get_dash(pointer, &lengths, &phase)
            
            return (phase: phase, lengths: lengths)
        }
        
        set {
            
            var lengthsCopy = newValue.lengths
            
            cairo_set_dash(pointer, &lengthsCopy, Int32(newValue.lengths.count), newValue.phase)
        }
    }
    
    public var miterLimit: Double {
        
        get { return cairo_get_miter_limit(pointer) }
        
        set { cairo_set_miter_limit(pointer, newValue) }
    }
    
    public var tolerance: Double {
        
        get { return cairo_get_tolerance(pointer) }
        
        set { cairo_set_tolerance(pointer, newValue) }
    }
    
    public var pathExtents: (x: Double, y: Double, width: Double, height: Double) {
        
        var x: Double = 0
        var y: Double = 0
        var width: Double = 0
        var height: Double = 0
        
        cairo_path_extents(pointer, &x, &y, &width, &height)
        
        return (x: x, y: y, width: width, height: height)
    }
    
    public var `operator`: cairo_operator_t {
        
        get { return cairo_get_operator(pointer) }
        
        set { cairo_set_operator(pointer, newValue) }
    }
    
    public var fontFace: FontFace {
        
        get {
            
            // This function never returns NULL. 
            // If memory cannot be allocated, a special "nil" `cairo_font_face_t` object will be returned
            let fontFacePointer = cairo_get_font_face(pointer)!
            
            guard cairo_font_face_status(fontFacePointer) != CAIRO_STATUS_NO_MEMORY
                else { fatalError("Memory cannot be allocated") }
            
            // hold reference
            cairo_font_face_reference(fontFacePointer)
            
            return FontFace(fontFacePointer)
        }
        
        set { cairo_set_font_face(pointer, newValue.pointer) }
    }
    
    public var scaledFont: ScaledFont {
        
        get {
            
            // This function never returns NULL.
            // If memory cannot be allocated, a special "nil" `cairo_scaled_font_t` object will be returned
            let scaledFontPointer = cairo_get_scaled_font(pointer)!
            
            guard cairo_scaled_font_status(scaledFontPointer) != CAIRO_STATUS_NO_MEMORY
                else { fatalError("Memory cannot be allocated") }
            
            // hold reference
            cairo_scaled_font_reference(scaledFontPointer)
            
            return ScaledFont(scaledFontPointer)
        }
        
        set { cairo_set_scaled_font(pointer, newValue.pointer) }
    }
}
