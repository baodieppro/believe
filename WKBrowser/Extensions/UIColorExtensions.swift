//
//  UIColorExtensions.swift
//  WKBrowser
//
//  Created by dali on 18/04/2017.
//  Copyright © 2017 itdali. All rights reserved.
//

import Foundation

private struct Color {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
}

extension UIColor {
    /**
     * Initializes and returns a color object for the given RGB hex integer.
     */
    public convenience init(rgb: Int, alpha: Float = 1) {
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((rgb & 0x0000FF) >> 0)  / 255.0,
            alpha: CGFloat(alpha))
    }
    
    
    /// get middle color from two color by step
    ///
    /// - Parameters:
    ///   - toColor: he second color
    ///   - step: the degree of change, 0.0 ~ 1.0
    /// - Returns: middle color
    func lerp(toColor: UIColor, step: CGFloat) -> UIColor {
        var fromR: CGFloat = 0
        var fromG: CGFloat = 0
        var fromB: CGFloat = 0
        getRed(&fromR, green: &fromG, blue: &fromB, alpha: nil)
        
        var toR: CGFloat = 0
        var toG: CGFloat = 0
        var toB: CGFloat = 0
        toColor.getRed(&toR, green: &toG, blue: &toB, alpha: nil)
        
        let r = fromR + (toR - fromR) * step
        let g = fromG + (toG - fromG) * step
        let b = fromB + (toB - fromB) * step
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    
    
    /// get a different blackness color by step
    ///
    /// - Parameter step: the degree of change, -1.0 ~ 1.0
    /// - Returns: UIColor
    func changeBlackness(step: CGFloat) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        
        return UIColor(red: (r - step), green: (g - step), blue: (b - step), alpha: 1)
    }
}
