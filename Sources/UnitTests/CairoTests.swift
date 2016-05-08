//
//  CairoTests.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 5/7/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import XCTest
import Cairo

final class CairoTests: XCTestCase {

    func testHelloWikipedia() {
        
        let filename = outputDirectory + "helloWiki.svg"
        
        print("Writing to \(filename)")
        
        //let surface = Surface
        let surface = Surface(pdf: filename, width: 100, height: 100)
        let context = Context(surface: surface)
        
        /// Draw the squares in the background
        for x in 0 ..< 10 {
            
            for y in 0 ..< 10 {
                
                context.addRectangle(x: Double(x) * 10.0, y: Double(y) * 10.0, width: 5.0, height: 5.0)
            }
        }
        
        let pattern = Cairo.Pattern(radial: (start: (center: (x: 50, y: 50), radius: 5), end: (center: (x: 50, y: 50), radius: 5)))
        
        pattern.addColorStop(offset: 0.0, red: 0.75, green: 0.15, blue: 0.99)
        
        pattern.addColorStop(offset: 0.9, red: 1.00, green: 1.00, blue: 1.00)
        
        context.setSource(pattern: pattern)
        
        context.fill()
        
        // Writing in the foreground
        
        context.setFont(size: 15.0)
        
        context.setFont(face: (family: "Georgia", slant: .normal, weight: .bold))
        
        context.setSource(color: (red: 0, green: 0, blue: 0))
        
        context.move(to: (x: 10, y: 25))
        context.show(text: "Hallo!")
        
        context.move(to: (x: 10, y: 75))
        context.show(text: "Wikipedia!")
        
        //let originalFile = outputDirectory + "helloWiki2.svg"
        
        //CairoTest.helloWikipedia(originalFile)
    }
    
    func testSourceX() {
        
        let filename = outputDirectory + "sourceX.png"
        
        print("Writing to \(filename)")
        
        CairoTest.sourceX(filename)
    }
}

#if os(OSX)
let outputDirectory = NSTemporaryDirectory()
#elseif os(Linux)
let outputDirectory = "/tmp/"
#endif
