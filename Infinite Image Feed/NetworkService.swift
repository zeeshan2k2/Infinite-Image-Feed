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
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        let images = try JSONDecoder().decode([ImageModel].self, from: data)
        
        return images
    }
}
