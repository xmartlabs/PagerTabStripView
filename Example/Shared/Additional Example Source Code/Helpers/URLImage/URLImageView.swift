//
//  URLImageView.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//  Adapted by Xmartlabs from https://github.com/SchwiftyUI/NewsApiApp/blob/master/NewsApp/Model/UrlImageModel.swift
//

import Foundation
import SwiftUI

struct URLImageView: View {
    @ObservedObject var urlImageModel: URLImageModel
    @Environment(\.colorScheme) var colorScheme

    init(urlString: String?) {
        urlImageModel = URLImageModel(urlString: urlString)
    }

    var body: some View {
        Image(uiImage: urlImageModel.image ?? URLImageView.defaultImage!)
            .resizable()
            .foregroundColor(colorScheme == .dark ? .white : .black )
    }

    static var defaultImage = UIImage(named: "defaultImage")
}
