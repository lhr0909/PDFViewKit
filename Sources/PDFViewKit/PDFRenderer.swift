//
//  PDFRenderer.swift
//  PDFViewKit
//
//  Copyright (C) 2024 Sören Gade
//  See LICENSE for full license.
//

import SwiftUI

@MainActor
public enum PDFRenderer {

    public static func render(
        document: PDFDocument,
        to destination: URL,
        atPageSize pageSize: some PageSize
    ) throws {
        let pdfSize = pageSize.size(atDPI: .pdf)
        let viewRenderingDPI: DPI = .display
        let viewSize = pageSize.size(atDPI: viewRenderingDPI)

        let viewToPDFScaleFactor = pdfSize.width / viewSize.width
        let rasterizationScaleFactor = DPI.print.rawValue / viewRenderingDPI.rawValue
        var box = CGRect(
            origin: .zero,
            size: pdfSize
        )
        guard let consumer = CGDataConsumer(url: destination as CFURL),
              let context = CGContext(consumer: consumer, mediaBox: &box, nil) else {
            throw Error.unableToCreateContext
        }

        for page in document.pages {
            let renderedView = page.body
                .environment(\.renderingEnvironment, .toPDF)
                .environment(\.pdfRenderingDPI, viewRenderingDPI)

            let renderer = ImageRenderer(content: renderedView)
            renderer.proposedSize = ProposedViewSize(viewSize)

            renderer.render(rasterizationScale: rasterizationScaleFactor) { _, renderer in
                context.beginPDFPage(nil)

                context.scaleBy(
                    x: viewToPDFScaleFactor,
                    y: viewToPDFScaleFactor
                )

                renderer(context)

                context.endPDFPage()
            }
        }

        context.closePDF()
    }

}

// MARK: - Errors

public extension PDFRenderer {

    enum Error: Swift.Error {

        case unableToCreateContext

    }

}
