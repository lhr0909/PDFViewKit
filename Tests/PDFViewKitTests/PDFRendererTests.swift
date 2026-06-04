//
//  PDFRendererTests.swift
//  PDFViewKit
//
//  Copyright (C) 2026 Sören Gade
//  See LICENSE for full license.
//

import Foundation
import PDFKit
@testable import PDFViewKit
import SwiftUI
import Testing

@MainActor
struct PDFRendererTests {

    @Test
    func renderedA4PageUsesPDFPointDimensions() throws {
        let destination = FileManager.default.temporaryDirectory
            .appendingPathComponent("PDFViewKit-A4-\(UUID().uuidString).pdf")
        defer { try? FileManager.default.removeItem(at: destination) }

        let document = PDFViewKit.PDFDocument {
            Text("Hello, A4")
        }

        try PDFRenderer.render(
            document: document,
            to: destination,
            atPageSize: DIN.a4
        )

        let pdfDocument = try #require(PDFDocument(url: destination))
        let page = try #require(pdfDocument.page(at: 0))

        let mediaBoxSize = page.bounds(for: .mediaBox).size

        #expect(abs(mediaBoxSize.width - a4SizeInPDFPoints.width) < pointTolerance)
        #expect(abs(mediaBoxSize.height - a4SizeInPDFPoints.height) < pointTolerance)
    }

    private var a4SizeInPDFPoints: CGSize {
        CGSize(
            width: 210 / 25.4 * DPI.pdf.rawValue,
            height: 297 / 25.4 * DPI.pdf.rawValue
        )
    }

    private var pointTolerance: CGFloat {
        0.001
    }

}
