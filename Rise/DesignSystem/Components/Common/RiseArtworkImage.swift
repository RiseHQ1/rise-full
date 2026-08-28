//
//  RiseArtworkImage.swift
//  Rise
//
//  Created by Rise Team on 28/08/2026.
//

import SwiftUI

/// Universal smart artwork image loader supporting both remote URLs (HTTP/HTTPS) and local asset catalog names.
public struct RiseArtworkImage: View {
    public let source: String
    public var fallbackAssetName: String
    public var contentMode: ContentMode

    public init(
        source: String,
        fallbackAssetName: String = "onboarding_motivation_bg",
        contentMode: ContentMode = .fill
    ) {
        self.source = source
        self.fallbackAssetName = fallbackAssetName
        self.contentMode = contentMode
    }

    public var body: some View {
        if source.starts(with: "http://") || source.starts(with: "https://") {
            AsyncImage(url: URL(string: source)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        RiseColors.surfaceField
                        ProgressView()
                            .tint(RiseColors.accentGold)
                    }
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                case .failure:
                    Image(fallbackAssetName)
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                @unknown default:
                    Image(fallbackAssetName)
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                }
            }
        } else {
            Image(source.isEmpty ? fallbackAssetName : source)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        }
    }
}
