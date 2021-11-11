//
//  AdapterForGetDataService.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 10.11.2021.
//

import Foundation
import UIKit

class AdapterForGetDataService {
    
    private let networkServices = NetworkServices()
    
    func getDataFromServerOrFromPhone(page: Int = 1, completion: @escaping(Swift.Result<[PhotableModel], AppError>) -> Void) {
        
        CheckOnlineStatusService.shared.checkServerPexelsIsOnline { [weak self] result in
            switch result {
            case true:
                self?.networkServices.getDataFromServer(page: page) { result in
                    switch result {
                    case .success(let photosArr):
                        print("Succes")
                        // saveToRealm once if is nothing in realm
                        if !RealmServices.shared.isPhotosInfoSaved {
                            let photoInfosToRealm = PhotosInfoModelFactory.shared.constructPhotoInfoRealmObject(photoModels: photosArr)
                            
                            //save to disk
                            photoInfosToRealm.forEach { [weak self] photoInfo in
                                guard let url = URL(string: photoInfo.urlPath) else { return }
                                self?.networkServices.downloadImage(url: url) { image in
                                    SaveNLoadToPhoneImageService.shared.saveImage(imageName: photoInfo.photoName, image: image.image)
                                    
                                    photoInfo.dateOfDownloaded = Int(image.dateOfDownloaded.timeIntervalSince1970)
                                }
                            }
                            RealmServices.shared.saveImagesInfo(imagesInfo: photoInfosToRealm)
                        } else {
                            
                        }
                        completion(.success(photosArr))
                    case .failure(let err):
                        print("Error", err)
                        if RealmServices.shared.isPhotosInfoSaved {
                            guard let photosInfo = RealmServices.shared.loadImagesInfo() else { return }
                            let photoOfflineModelArr = PhotosInfoModelFactory.shared.convertPhotoInfoRealmObjectToPhotoOfflineModel(photosInfos: photosInfo)
                            completion(.success(photoOfflineModelArr))
                        } else {
                            completion(.failure(AppError.offlineAndNoDataDownloaded))
                        }
                    }
                }
            case false:
                if RealmServices.shared.isPhotosInfoSaved {
                    guard let photosInfo = RealmServices.shared.loadImagesInfo() else { return }
                    let photoOfflineModelArr = PhotosInfoModelFactory.shared.convertPhotoInfoRealmObjectToPhotoOfflineModel(photosInfos: photosInfo)
                    completion(.success(photoOfflineModelArr))
                } else {
                    completion(.failure(AppError.offlineAndNoDataDownloaded))
                }
            }
        }
    }
    
}



