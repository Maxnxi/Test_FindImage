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
//                let previousCount = oldValue.count-1
//                let newCount = self.photosCellViewModel.count-1
//                let intArr = Array(previousCount...newCount)
//                let indexPaths = intArr.map { IndexPath(row: $0, section: 0) }
//                self.collectionView.reloadItems(at: indexPaths)
                self.collectionView.reloadData()
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
        //загрузить фото
        loadNewPhoto()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //RealmServices.shared.cleanAll()
    }
    
    func loadNewPhoto(page: Int = 1) {
        
        adapterForGetDataService.getDataFromServerOrFromPhone(page: page) { [weak self] result in
            self?.pageOfImages += 1
            switch result {
            case .success(let photobaleModelArr):
                guard let cellViewMArrBase = self?.photosCellViewModel else { return }
                print("cellViewMArrBase.count is - ", cellViewMArrBase.count)
                print("photobaleModelArr.first is - ", photobaleModelArr.first?.dateOfDownloaded)
                PhotosInfoModelFactory.shared.convertPhotableModelToCellViewModel(photos: photobaleModelArr) { [weak self] photos in
                    // сохраняем в realm и на диск если статус online
                    if CheckOnlineStatusService.shared.isOnline == true {
                        print("CheckOnlineStatusService.shared.isOnline")
                        self?.adapterForGetDataService.savePhotosToRealmAndDisk(cellViewModels: photos) { result in
                            
                        }
                    } else {
                        // если статус offline
                        self?.createOfflineLabel()
                    }
                    
                    
                    // добавляем к массиву который выводится в коллекцию
                    let tmpCellVMArr = cellViewMArrBase + photos
                    print("tmpCellVMArr.count is - ", tmpCellVMArr.count)
                    self?.photosCellViewModel = tmpCellVMArr
                }
            case .failure(let err):
                print("Error - ", err)
                
                DispatchQueue.main.async {
                    self?.createOfflineLabel()
                }
            }
        }
    }
    
    func createOfflineLabel() {
        let rect = CGRect(x: 10, y: -10, width: 200, height: 200)
        let label = UILabel(frame: rect)
        label.text = "No Internet connection"
        label.numberOfLines = 0
        label.sizeThatFits(rect.size)
        label.textColor = UIColor.white
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.offlineLabelTapped(_:)))
        label.addGestureRecognizer(tapGesture)
        self.view.superview?.addSubview(label)
    }
    
    @objc func offlineLabelTapped(_ sender: UITapGestureRecognizer) {
        print("Label tapped")
        //self.photosCellViewModel.removeAll()
        self.loadNewPhoto()
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
        if CheckOnlineStatusService.shared.isOnline == true {
            if (indexPath.row == photosCellViewModel.count - 4 ) {
                loadNewPhoto(page: pageOfImages)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: DetailVC.reuseIdentifierOfVC) as? DetailVC else { return }
        viewController.cellViewModel = photosCellViewModel[indexPath.row]
        self.present(viewController, animated: true, completion: nil)
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
