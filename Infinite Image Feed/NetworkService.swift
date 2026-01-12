//
//  NetworkService.swift
//  Infinite Image Feed
//
//  Created by Zeeshan Waheed on 12/01/2026.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    private let accessKey = "lAWlnYJon3OGj5jo1RXYyGCq7cHRBGnQ1cljLrvStT0"
    private let baseURL = "https://api.unsplash.com/photos"
    
    func fetchImages(page: Int) async throws -> [ImageModel] {
        let urlString = "\(baseURL)?page=\(page)&per_page=10&client_id=\(accessKey)"
        
        print("🌐 Fetching URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            throw URLError(.badURL)
        }
        
        print("📡 Making network request...")
        let (data, response) = try await URLSession.shared.data(from: url)
        
//        if let httpResponse = response as? HTTPURLResponse {
//            print("📊 Status Code: \(httpResponse.statusCode)")
//        }
//        
//        print("📦 Received data size: \(data.count) bytes")
//        
//        if let jsonString = String(data: data, encoding: .utf8) {
//            print("📄 Response JSON: \(jsonString.prefix(500))")
//        }
        
        let images = try JSONDecoder().decode([ImageModel].self, from: data)
        print("✅ Successfully decoded \(images.count) images")
        
        return images
    }
}
