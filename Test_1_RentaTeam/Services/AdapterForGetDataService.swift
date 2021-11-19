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
                // если сайт онлайн то - скачать новые фотки
                print("Server pexels is online")
                self?.networkServices.getDataFromServer(page: page) { result in
                    switch result {
                    case .success(let photosArr):
                        print("Succes")
                        completion(.success(photosArr))
                    case .failure(let err):
                        // если запрос не удался проверить Realm
                        print("Error getting info from server", err)
                        self?.getDataFromRealmAndDisk(completion: { result in
                            switch result {
                            case .success(let photosArr):
                                completion(.success(photosArr))
                            case .failure(let err):
                                completion(.failure(err))
                            }
                        })
                    }
                }
            case false:
                // если сайт оффлайн то - достать фотки из базы и с диска
                print("Server pexels is offline")
                self?.getDataFromRealmAndDisk(completion: { result in
                    switch result {
                    case .success(let photosArr):
                        print("Get data from disk - ", photosArr.count)
                        completion(.success(photosArr))
                    case .failure(let err):
                        print("Can not get data from disk")
                        completion(.failure(err))
                    }
                })
            }
        }
    }
    
    private func getDataFromRealmAndDisk(completion: @escaping(Swift.Result<[PhotableModel], AppError>) -> ()) {
        // проверить есть ли данные в realm
        if RealmServices.shared.isRealmEmpty == false {
            print("RealmServices.shared.isRealmEmpty - ", RealmServices.shared.isRealmEmpty )
            // получить данные из realm
            guard let photosInfo = RealmServices.shared.loadImagesInfo() else { return }
            print("photosInfo count - ", photosInfo.count)
            // сформировать PhotableModel
            var photoModelArray: [PhotoOfflineModel] = []
            photosInfo.forEach { photoInfo in
                let photoOfflineModel = PhotosInfoModelFactory.shared.convertPhotoInfoRealmObjectToPhotoOfflineModel(photoInfo: photoInfo)
                photoModelArray.append(photoOfflineModel)
            }
            if photoModelArray.count == photosInfo.count {
                completion(.success(photoModelArray))
            }
        } else {
            print("RealmServices.shared.isRealmEmpty - ", RealmServices.shared.isRealmEmpty )
            completion(.failure(AppError.offlineAndNoDataDownloaded))
        }
    }
    
    func savePhotosToRealmAndDisk(cellViewModels: [CellViewModel], completion: @escaping(_ result: Bool) -> ()) {
        RealmServices.shared.cleanAll()
        cellViewModels.forEach { cellViewModel in
            // конвертировать cellViewModels  в RealmObject
            let photoRealm = PhotosInfoModelFactory.shared.convertCellViewModelToRealmObject(photo: cellViewModel)
            // сохранить в Realm
            
            RealmServices.shared.saveImageInfo(imageInfo: photoRealm)
            // сохранить на диск
            SaveNLoadToPhoneImageService.shared.saveImage(imageName: photoRealm.photoName, image: cellViewModel.image)
            print("Photo saved - # ", cellViewModel.id)
        }
    }
    
}



