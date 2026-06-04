//
//  DPI.swift
//  PDFViewKit
//
//  Copyright (C) 2024 Sören Gade
//  See LICENSE for full license.
//

import Foundation

/// Defines specific dots per inch resolutions.
public enum DPI: CGFloat {

    // based on https://www.adobe.com/uk/creativecloud/photography/discover/dots-per-inch-dpi-resolution.html

    case pdf = 72 // PDF user-space points (1/72 inch)

    case display = 96
    case displayHigh = 144 // 150%

    case print = 300
    case printArtwork = 600

}
