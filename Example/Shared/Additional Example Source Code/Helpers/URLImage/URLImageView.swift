//
//  URLImageView.swift
//  Example (iOS)
//
//  Copyright © 2022 Xmartlabs SRL. All rights reserved.
//  Adapted by Xmartlabs from https://github.com/SchwiftyUI/NewsApiApp/blob/master/NewsApp/Model/UrlImageModel.swift
//

import Foundation
import SwiftUI

struct URLImageView: View {
    @StateObject var urlImageModel: URLImageModel
    @Environment(\.colorScheme) var colorScheme

    init(urlString: String) {
        _urlImageModel = StateObject(wrappedValue: URLImageModel(urlString: urlString))
    }

    @MainActor var body: some View {
        Image(uiImage: urlImageModel.image ?? URLImageView.defaultImage!)
            .resizable()
            .foregroundColor(colorScheme == .dark ? .white : .black )
    }

    static var defaultImage = UIImage(named: "defaultImage")
}
