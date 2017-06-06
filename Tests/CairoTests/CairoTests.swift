//
//  CairoTests.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 5/7/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import XCTest
import Foundation
@testable import Cairo

final class CairoTests: XCTestCase {
    
    static let allTests = [
        ("testSourceX", testSourceX),
        ("testImageFormats", testImageFormats),
        ("testReadPNGData", testReadPNGData),
        ("testPDFSurface", testPDFSurface)
        ]
    
    func testSourceX() {
        
        let testFilename = outputDirectory + "sourceX.png"
        
        let size = 300
        
        let surface = try! Surface.Image(format: .argb32, width: size, height: size)
        
        let context = Cairo.Context(surface: surface)
        
        context.drawSourceX(size: size)
        
        surface.writePNG(atPath: testFilename)
        
        print("Wrote \(#function) test to \(testFilename)")
    }
    
    func testImageFormats() {
        
        writeTestPNG(testName: "testImageFormats")
    }
    
    func testReadPNGData() {
        
        writeTestPNG(testName: "testReadPNGData") { (surface, testFilename) in
            
            let pngData = try! Data(contentsOf: URL(fileURLWithPath: testFilename))
            
            guard let pngSurface = try? Surface.Image(png: pngData)
                else { XCTFail("Could not create surface from data"); return }
            
            print("Created PNG surface with \(pngSurface.format!) image format")
            
            XCTAssert(pngSurface.width == surface.width)
            XCTAssert(pngSurface.height == surface.height)
            XCTAssert(pngSurface.data != nil)
            
            /// Image surfaces created from PNG are always `argb32`
            if surface.format == .argb32 {
                
                XCTAssert(pngSurface.stride == surface.stride)
                XCTAssert(pngSurface.data == surface.data)
            }
        }
    }
    
    func testPDFSurface() {
        
        let testName = "testPDFSurface"
        
        func fileName(for size: Int) -> String {
            
            return outputDirectory + "\(testName)_\(size).pdf"
        }
        
        testDraw(createSurface:{ try! Surface.PDF(filename: fileName(for: $0), width: Double($0), height: Double($0)) }) { (surface) in
            
            surface.flush()
            surface.finish()
            
            
            
            print("Wrote \(#function) test to \(testFilename)")
        }
    }
}

fileprivate extension Context {
    
    func drawSourceX(size: Int) {
        
        let context = self
        
        // Examples are in 1.0 x 1.0 coordinate space
        context.scale(x: Double(size), y: Double(size))
        
        // Drawing code goes here
        context.setSource(color: (red: 0, green: 0, blue: 0))
        context.move(to: (x: 0, y: 0))
        context.line(to: (x: 1, y: 1))
        context.move(to: (x: 1, y: 0))
        context.line(to: (x: 0, y: 1))
        context.lineWidth = 0.2
        context.stroke()
        
        context.addRectangle(x: 0, y: 0, width: 0.5, height: 0.5)
        context.setSource(color: (red: 1, green: 0, blue: 0, alpha: 0.8))
        context.fill()
        
        context.addRectangle(x: 0, y: 0.5, width: 0.5, height: 0.5)
        context.setSource(color: (red: 0, green: 1, blue: 0, alpha: 0.6))
        context.fill()
        
        context.addRectangle(x: 0.5, y: 0, width: 0.5, height: 0.5)
        context.setSource(color: (red: 0, green: 0, blue: 1, alpha: 0.4))
        context.fill()
    }
}

fileprivate extension CairoTests {
    
    func testDraw<T: Surface>(functionName: String = #function,
                  createSurface: (_ size: Int) -> (T),
                  forEach: ((_ surface: T) -> ())? = nil) {
        
        let sizes = [10, 20, 50, 100, 200, 500, 1000, 10000]
        
        for size in sizes {
            
            let surface = createSurface(size)
            
            let context = Cairo.Context(surface: surface)
            
            context.drawSourceX(size: size)
            
            forEach?(surface)
        }
    }
    
    func writeTestPNG(testName: String,
                      functionName: String = #function,
                      forEach: ((_ surface: Surface.Image, _ filename: String) -> ())? = nil) {
        
        let formats: [ImageFormat] = [.argb32, .rgb24, .a8, .a1, .rgb16565, .rgb30]
        
        let sizes = [1, 10, 20, 50, 100, 200, 500, 1000, 10000]
        
        for format in formats {
            
            for size in sizes {
                
                let surface = try! Surface.Image(format: format, width: size, height: size)
                
                let context = Cairo.Context(surface: surface)
                
                context.drawSourceX(size: size)
                
                let testFilename = outputDirectory + "\(testName)_\(format)_\(size).png"
                
                surface.writePNG(atPath: testFilename)
                
                print("Wrote \(functionName) test to \(testFilename)")
                
                forEach?(surface, testFilename)
            }
        }
    }
}

let outputDirectory: String = {
   
    let outputDirectory = NSTemporaryDirectory() + "CairoTest" + "/"
    
    var isDirectory: ObjCBool = false
    
    // Create test folder
    if FileManager.default.fileExists(atPath: outputDirectory, isDirectory: &isDirectory) == false {
        
        try! FileManager.default.createDirectory(atPath: outputDirectory, withIntermediateDirectories: false)
    }
    
    // remove all files in directory (previous test cache)
    let contents = try! FileManager.default.contentsOfDirectory(atPath: outputDirectory)
    
    contents.forEach { try! FileManager.default.removeItem(atPath: outputDirectory + $0) }
    
    return outputDirectory
}()
