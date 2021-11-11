//
//  MainViewController.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 09.11.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    var pageOfImages: Int = 1
    var photosCellViewModel: [CellViewModel] = [] {
        didSet {
            print("Setted")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
//                Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
//                    self?.collectionView.reloadData()
//                }
            }
            
        }
    }
    private let networkServices = NetworkServices()
    private let adapterForGetDataService = AdapterForGetDataService()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView?.prefetchDataSource = self
        loadNewPhoto()
    }
    
    func loadNewPhoto(page: Int = 1) {
        adapterForGetDataService.getDataFromServerOrFromPhone(page: page) { [weak self] result in
            self?.pageOfImages += 1
            switch result {
            case .success(let photobaleModelArr):
                guard let cellViewMArrBase = self?.photosCellViewModel else { return }
                print("cellViewMArrBase.count is - ", cellViewMArrBase.count)
                
                PhotosInfoModelFactory.shared.convertPhotableModelToCellViewModel(photos: photobaleModelArr) { photos in
                    let tmpCellVMArr = cellViewMArrBase + photos
                    print("tmpCellVMArr.count is - ", tmpCellVMArr.count)
                    self?.photosCellViewModel = tmpCellVMArr
                }
            case .failure(let err):
                print("Error - ", err)
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
