//
//  PhotosInfoModelFactory.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 10.11.2021.
//

import Foundation
import UIKit

class PhotosInfoModelFactory {
    
    private let networkServices = NetworkServices()
    
    static let shared = PhotosInfoModelFactory()
    
    func constructPhotoInfoRealmObject(photoModels: [PhotoModel]) -> [PhotoInfoRealmObject] {
        var tmpPhotosInfoArr: [PhotoInfoRealmObject] = []
        for index in 0..<photoModels.count {
            let photoInfo = photoModels[index]
            let photoInfoToRealm = PhotoInfoRealmObject()
            photoInfoToRealm.photoId = photoInfo.id
            photoInfoToRealm.photographerName = photoInfo.photographer
            photoInfoToRealm.avgColor = photoInfo.avgColor
            photoInfoToRealm.photoName = String(photoInfo.url.suffix(7))
            photoInfoToRealm.urlPath = photoInfo.url
            tmpPhotosInfoArr.append(photoInfoToRealm)
        }
        return tmpPhotosInfoArr
    }
    
    func convertPhotoInfoRealmObjectToPhotoOfflineModel(photosInfos: [PhotoInfoRealmObject]) -> [PhotoOfflineModel] {
        var tmpPhotosOffModelArr: [PhotoOfflineModel] = []
        for index in 0..<photosInfos.count {
            let photoInfo = photosInfos[index]
            let image = (SaveNLoadToPhoneImageService.shared.loadImageFromDiskWith(fileName: photoInfo.photoName)) ?? UIImage(named: "square.fil")
            let photoOffModel = PhotoOfflineModel(id: photoInfo.photoId , photographer: photoInfo.photographerName, averageColor: photoInfo.avgColor, photoName: photoInfo.photoName, url: photoInfo.urlPath, dateOfDownload: photoInfo.dateOfDownloaded, image: (image ?? UIImage(named: "cat"))!)
            tmpPhotosOffModelArr.append(photoOffModel)
        }
        return tmpPhotosOffModelArr
    }
    
    func convertPhotableModelToCellViewModel(photos: [PhotableModel], completion: @escaping(_ modelArrays: [CellViewModel]) -> ()) {
        var tmpCellViewModel: [CellViewModel] = []
        
        photos.forEach { [weak self] photo in
            var imageTmp = UIImage()
            var dateOfDownloaded: Int = 0
            
            if let image = photo.image {
                print("convertPhotableModelToCellViewModel - image is here")
                imageTmp = image
                dateOfDownloaded = photo.dateOfDownloaded ?? -1
                let idString = String(photo.id)
                let dateDownloadString = String(dateOfDownloaded)
                let cellViewModel = CellViewModel(image: imageTmp, id: idString, photoGrapherName: photo.photographer, downoladDate: dateDownloadString)
                tmpCellViewModel.append(cellViewModel)
                if tmpCellViewModel.count == photos.count {
                    print("Completion in convertPhotableModelToCellViewModel")
                    completion(tmpCellViewModel)
                }
                
            } else {
                print("convertPhotableModelToCellViewModel - image is not here")
                if let url = URL(string: photo.url) {
                    networkServices.downloadImage(url: url) { [weak self] image in
                        print("Downloaded image - ", image.image)
                        imageTmp = image.image
                        dateOfDownloaded = Int(image.dateOfDownloaded.timeIntervalSince1970)
                        // bug here
                        let idString = String(photo.id)
                        let dateDownloadString = String(dateOfDownloaded)
                        let cellViewModel = CellViewModel(image: imageTmp, id: idString, photoGrapherName: photo.photographer, downoladDate: dateDownloadString)
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
            }
        }
    }
    
}

