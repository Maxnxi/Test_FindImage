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
                print("Server pexels is online")
                self?.networkServices.getDataFromServer(page: page) { result in
                    switch result {
                    case .success(let photosArr):
                        print("Succes")
                        // saveToRealm once if is nothing in realm
                        //if !RealmServices.shared.isPhotosInfoSaved {
                        //print("RealmServices.shared.isPhotosInfoSaved == else - ", RealmServices.shared.isPhotosInfoSaved)
                        let photoInfosToRealm = PhotosInfoModelFactory.shared.constructPhotoInfoRealmObject(photoModels: photosArr)
                        RealmServices.shared.saveImagesInfo(imagesInfo: photoInfosToRealm)
                        //save to disk
                        photoInfosToRealm.forEach { [weak self] photoInfo in
                            guard let url = URL(string: photoInfo.urlPath) else { return }
                            self?.networkServices.downloadImage(url: url) { image in
                                SaveNLoadToPhoneImageService.shared.saveImage(imageName: photoInfo.photoName, image: image.image)
                                
                                photoInfo.dateOfDownloaded = Int(image.dateOfDownloaded.timeIntervalSince1970)
                            }
                        }
                        
//                        { result in
//                            switch result {
//                            case true:
//                                completion(.success(photosArr))
//                            case false:
//                                completion(.failure(AppError.errorInSaving))
//                            }
//                        }
//                        } else {
//                            print("RealmServices.shared.isPhotosInfoSaved == else - ", RealmServices.shared.isPhotosInfoSaved)
//                        }
                        if photoInfosToRealm.last?.dateOfDownloaded != nil {
                            //RealmServices.shared.saveImagesInfo(imagesInfo: photoInfosToRealm)
                            completion(.success(photosArr))
                        }
                        
                    case .failure(let err):
                        print("Error getting info from server", err)
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
                print("Server pexels is offline")
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



