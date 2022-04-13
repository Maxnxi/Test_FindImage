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
        photoInfoToRealm.photoName = String(photo.url.suffix(7)) + ".png"
        photoInfoToRealm.urlPath = photo.url
        return photoInfoToRealm
    }
    
    func convertPhotableModelToCellViewModel(photos: [PhotableModel], completion: @escaping(_ modelArrays: [CellViewModel]) -> ()) {
        var tmpCellViewModel: [CellViewModel] = []
        photos.forEach { [weak self] photo in
            var imageTmp = UIImage()
            var dateOfDownloaded: Int = 0
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
        }
    }
    
}

