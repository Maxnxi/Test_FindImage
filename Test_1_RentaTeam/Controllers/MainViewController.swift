//
//  MainViewController.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 09.11.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    var pageOfImages: Int = 2
    var photosCellViewModel: [CellViewModel] = []{
        didSet {
            collectionView.reloadData()
        }
    }
    private let networkServices = NetworkServices()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView?.prefetchDataSource = self
        loadNewPhoto()
    }
    
    func loadNewPhoto(page: Int = 1) {
        networkServices.getDataFromServer(page: page) { [weak self] result in
            self?.pageOfImages += 1
            switch result {
            case .success(let photosArr):
                print("Succes")
                photosArr.forEach { photo in
                    guard let url = URL(string: photo.url),
                          let idString = String(photo.id) as? String else { return }
                    self?.networkServices.downloadImage(url: url) { photoCache in
                        
                        let cellViewModel = CellViewModel(image: photoCache.image, id: idString, photoGrapherName: photo.photographer, downoladDate: photoCache.dateOfDownloaded)
                        
                        self?.photosCellViewModel.append(cellViewModel)
                    }
                }
            case .failure(let err):
                print("Error", err)
            }
        }
    }
    
}

extension MainViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("Prefetch: \(indexPaths)")
        loadNewPhoto(page: pageOfImages)
        
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosCellViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainViewCell", for: indexPath) as? MainViewCell else {
            print("Error - in collectionView - cellForItemAt")
            return UICollectionViewCell()
        }
        cell.configureCell(viewModel: photosCellViewModel[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == photosCellViewModel.count - 2 ) {
            loadNewPhoto(page: pageOfImages)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    enum CollectionLayout {
        static let columns = 2
        static let cellHeight: CGFloat = 150
        static let cellWidth: CGFloat = 250
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 350, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
