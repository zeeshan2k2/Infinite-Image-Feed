//
//  ImageModel.swift
//  Infinite Image Feed
//
//  Created by Zeeshan Waheed on 12/01/2026.
//

import Foundation

struct ImageModel: Codable {
    let id: String
    let urls: ImageURLs
}

struct ImageURLs: Codable {
    let regular: String
    let small: String
}
