//
//  ViewController.swift
//  Infinite Image Feed
//
//  Created by Zeeshan Waheed on 11/01/2026.
//

import UIKit

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [ImageModel] = []
    var currentPage = 1
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        loadImages()
    }
    
    func loadImages() {
        guard !isLoading else { return }
        
        isLoading = true
        
        Task {
            do {
                let newImages = try await NetworkService.shared.fetchImages(page: currentPage)
                
                images.append(contentsOf: newImages)
                collectionView.reloadData()
                
                currentPage += 1
                isLoading = false
            } catch {
                isLoading = false
            }
        }
    }
}

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionCell
        
        let imageModel = images[indexPath.item]
        cell.configure(with: imageModel.urls.small)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 200 {
            loadImages()
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfColumns: CGFloat = 2
        let spacing: CGFloat = 10
        let totalSpacing = spacing * (numberOfColumns - 1)
        
        let width = (collectionView.bounds.width - totalSpacing) / numberOfColumns
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
