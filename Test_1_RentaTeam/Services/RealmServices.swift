//
//  RealmServices.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 10.11.2021.
//

import Foundation
import RealmSwift

class RealmServices {
    
    static let shared = RealmServices()
    
    lazy var isRealmEmpty: Bool = {
       return checkIfRealmIsNotEmpty()
    }()
    
    private init() {
        isRealmEmpty = checkIfRealmIsNotEmpty()
    }
    
    private func checkIfRealmIsNotEmpty() -> Bool {
        do {
            let realm = try Realm()
            print("realm.isEmpty", realm.isEmpty)
            return realm.isEmpty
        } catch {
            print("Error in RealmServices - checkIfRealmIsNotEmpty")
        }
        return false
    }
    
    // сохранить один элемент
    public func saveImageInfo(imageInfo: PhotoInfoRealmObject) {
            do {
                let realm = try Realm()
                try realm.write({
                    realm.add(imageInfo)
                })
            } catch let error as NSError {
                print("Error in RealmServices - loadImagesInfo: ", error)
            }
    }
   
    // сохранить массив
    public func saveImagesInfo(imagesInfo: [PhotoInfoRealmObject]) {
        var objectCount = 0
            do {
                let realm = try Realm()
                try realm.write({
                    realm.deleteAll()
                    imagesInfo.forEach { photoInfo in
                        realm.add(photoInfo)
                        print("Save object - #", objectCount)
                        objectCount += 1
                    }
                })
            } catch let error as NSError {
                print("Error in RealmServices - loadImagesInfo: ", error)
            }
    }
    
    public func loadImagesInfo() -> [PhotoInfoRealmObject]? {
        do {
            let realm = try Realm()
            let result = realm.objects(PhotoInfoRealmObject.self)
            let imagesInfo = Array(result)
            return imagesInfo
        } catch let error as NSError {
            print("Error in RealmServices - loadImagesInfo: ", error)
            return nil
        }
    }
    
    public func cleanAll() {
        // удалить с диска
        guard let currentRealmObjects = self.loadImagesInfo() else { return }
        currentRealmObjects.forEach({ realmObject in
            SaveNLoadToPhoneImageService.shared.deleteImageFromDisk(fileName: realmObject.photoName)
        })
        // удалить из Realm
        do {
            let realm = try Realm()
            try realm.write({
                realm.deleteAll()
            })
        } catch let error as NSError {
            print("Error in RealmServices - cleanAll: ", error)
        }
    }
    
}
