//
//  ImageCell.swift
//  Infinite Image Feed
//
//  Created by Zeeshan Waheed on 11/01/2026.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var loadingTask: Task<Void, Never>?
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadingTask?.cancel()
        imageView.image = nil
        activityIndicator.stopAnimating()
    }
    
    func configure(with imageURL: String) {
        imageView.image = nil
        imageView.backgroundColor = .systemGray6
        
        if let cachedImage = ImageCache.shared.get(forKey: imageURL) {
            imageView.image = cachedImage
            activityIndicator.stopAnimating()
            return
        }
        
        activityIndicator.startAnimating()
        
        guard let url = URL(string: imageURL) else { return }
        
        loadingTask = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard !Task.isCancelled else { return }
                
                if let image = UIImage(data: data) {
                    ImageCache.shared.set(image, forKey: imageURL)
                    
                    await MainActor.run {
                        self.imageView.image = image
                        self.activityIndicator.stopAnimating()
                    }
                }
            } catch {
                await MainActor.run {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
