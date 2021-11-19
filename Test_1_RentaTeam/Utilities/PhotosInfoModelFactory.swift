//
//  PhotosInfoModelFactory.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 10.11.2021.
//

import Foundation
import UIKit
import RealmSwift

class PhotosInfoModelFactory {
    
    private let networkServices = NetworkServices()
    
    static let shared = PhotosInfoModelFactory()
    
//    func constructPhotoInfoRealmObject(photoModels: [PhotoModel]) -> [PhotoInfoRealmObject] {
//        var tmpPhotosInfoArr: [PhotoInfoRealmObject] = []
//        for index in 0..<photoModels.count {
//            let photoInfo = photoModels[index]
//            
//            let photoInfoToRealm = PhotoInfoRealmObject()
//            photoInfoToRealm.photoId = "\(photoInfo.id)"
//            photoInfoToRealm.photographerName = photoInfo.photographer
//            photoInfoToRealm.avgColor = photoInfo.avgColor
//            photoInfoToRealm.photoName = String(photoInfo.url.suffix(7)) + ".png"
//            photoInfoToRealm.urlPath = photoInfo.url
//            tmpPhotosInfoArr.append(photoInfoToRealm)
//        }
//        return tmpPhotosInfoArr
//    }
    
    func convertPhotoInfoRealmObjectToPhotoOfflineModel(photoInfo: PhotoInfoRealmObject) -> PhotoOfflineModel {
        var tmpImage = UIImage()
        if let image = SaveNLoadToPhoneImageService.shared.loadImageFromDiskWith(fileName: photoInfo.photoName) {
            tmpImage = image
        } else {
            if let image = UIImage(named: "cat") {
            tmpImage = image
            }
        }
        let photoOffModel = PhotoOfflineModel(id: photoInfo.photoId,
                                                  photographer: photoInfo.photographerName,
                                                  photoName: photoInfo.photoName,
                                                  url: photoInfo.urlPath,
                                                  dateOfDownload: photoInfo.dateOfDownloaded,
                                                  image: tmpImage)
        return photoOffModel
    }
    
    func convertCellViewModelToRealmObject(photo: CellViewModel) -> PhotoInfoRealmObject {
            let photoInfoToRealm = PhotoInfoRealmObject()
            photoInfoToRealm.photoId = photo.id
            photoInfoToRealm.photographerName = photo.photoGrapherName
            //photoInfoToRealm.avgColor = photoInfo.avgColor
            photoInfoToRealm.photoName = String(photo.url.suffix(7)) + ".png"
            photoInfoToRealm.urlPath = photo.url
        return photoInfoToRealm
    }
    
    
    
//    func convertCellViewModelToRealmObject(photos: [CellViewModel], completion: @escaping(_ realmPhotosInfo: [PhotoInfoRealmObject]) -> ()) {
//
//        var realmPhotosInfo: [PhotoInfoRealmObject] = []
//        photos.forEach { cellViewModel in
//            let photoInfoToRealm = PhotoInfoRealmObject()
//            photoInfoToRealm.photoId = cellViewModel.id
//            photoInfoToRealm.photographerName = cellViewModel.photoGrapherName
//            //photoInfoToRealm.avgColor = photoInfo.avgColor
//            photoInfoToRealm.photoName = String(cellViewModel.url.suffix(7)) + ".png"
//            photoInfoToRealm.urlPath = cellViewModel.url
//            realmPhotosInfo.append(photoInfoToRealm)
//        }
//
//        if photos.count == realmPhotosInfo.count {
//            completion(realmPhotosInfo)
//        }
//    }
    
    
    func convertPhotableModelToCellViewModel(photos: [PhotableModel], completion: @escaping(_ modelArrays: [CellViewModel]) -> ()) {
        
        var tmpCellViewModel: [CellViewModel] = []
        
        photos.forEach { [weak self] photo in
            var imageTmp = UIImage()
            var dateOfDownloaded: Int = 0
            
//            if let image = photo.image {
//                print("convertPhotableModelToCellViewModel - image is here")
//                imageTmp = image
//                dateOfDownloaded = photo.dateOfDownloaded ?? -1
//                let idString = String(photo.id)
//                let dateDownloadString = String(dateOfDownloaded)
//                let cellViewModel = CellViewModel(image: imageTmp, id: idString, photoGrapherName: photo.photographer, downoladDate: dateDownloadString)
//                tmpCellViewModel.append(cellViewModel)
//                if tmpCellViewModel.count == photos.count {
//                    print("Completion in convertPhotableModelToCellViewModel")
//                    completion(tmpCellViewModel)
//                }
//            } else {
                
                //print("convertPhotableModelToCellViewModel - image is not here")
                if let url = URL(string: photo.url) {
                    networkServices.downloadImage(url: url) { [weak self] image in
                        guard let image = image else {
                            print("Error in convertPhotableModelToCellViewModel - doing networkServices.downloadImage ")
                            return
                        }
                        print("Downloaded image - ", image.image)
                        
                        imageTmp = image.image
                        dateOfDownloaded = Int(image.dateOfDownloaded.timeIntervalSince1970)
                        
                        let idString = String(photo.id)
                        let dateDownloadString = String(dateOfDownloaded)
                        
                        let cellViewModel = CellViewModel(image: imageTmp, id: idString, photoGrapherName: photo.photographer, downoladDate: dateDownloadString, url: photo.url)
                        tmpCellViewModel.append(cellViewModel)
                        if tmpCellViewModel.count == photos.count {
                            print("Completion in convertPhotableModelToCellViewModel")
                            completion(tmpCellViewModel)
                        }
                    }
                } else {
                    // todo smth if url failed
                    print("todo smth if url failed")
                }
            //}
        }
    }
    
}

