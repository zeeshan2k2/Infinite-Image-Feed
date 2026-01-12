//
//  TableViewController.swift
//  Infinite Image Feed
//
//  Created by Zeeshan Waheed on 12/01/2026.
//


import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var images: [ImageModel] = []
    var currentPage = 1
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 90
        
        tableView.separatorStyle = .none
        
        loadImages()
    }
    
    func loadImages() {
        guard !isLoading else { return }
        
        isLoading = true
        
        Task {
            do {
                let newImages = try await NetworkService.shared.fetchImages(page: currentPage)
                
                images.append(contentsOf: newImages)
                
                await MainActor.run {
                    tableView.reloadData()
                }
                
                currentPage += 1
                isLoading = false
            } catch {
                isLoading = false
            }
        }
    }
}

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageTableCell
        
        let imageModel = images[indexPath.row]
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
