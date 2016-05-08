//
//  CairoTest.m
//  Cairo
//
//  Created by Alsey Coleman Miller on 5/8/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

#import "CairoTest.h"
#import <cairo/cairo.h>

@implementation CairoTest

+ (void)helloWikipedia:(NSString *)filename
{
    cairo_t *cr;
    cairo_surface_t *surface;
    cairo_pattern_t *pattern;
    int x,y;
    
    surface =
    (cairo_surface_t *)cairo_svg_surface_create("Cairo_example.svg", 100.0, 100.0);
    cr = cairo_create(surface);
    
    /* Draw the squares in the background */
    for (x=0; x<10; x++)
        for (y=0; y<10; y++)
            cairo_rectangle(cr, x*10.0, y*10.0, 5, 5);
    
    pattern = cairo_pattern_create_radial(50, 50, 5, 50, 50, 50);
    cairo_pattern_add_color_stop_rgb(pattern, 0, 0.75, 0.15, 0.99);
    cairo_pattern_add_color_stop_rgb(pattern, 0.9, 1, 1, 1);
    
    cairo_set_source(cr, pattern);
    cairo_fill(cr);
    
    /* Writing in the foreground */
    cairo_set_font_size (cr, 15);
    cairo_select_font_face (cr, "Georgia",
                            CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD);
    cairo_set_source_rgb (cr, 0, 0, 0);
    
    cairo_move_to(cr, 10, 25);
    cairo_show_text(cr, "Hallo");
    
    cairo_move_to(cr, 10, 75);
    cairo_show_text(cr, "Wikipedia!");
    
    cairo_destroy (cr);
    cairo_surface_destroy (surface);
}

@end
