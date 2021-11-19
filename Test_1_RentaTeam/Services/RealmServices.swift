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
                    //realm.deleteAll()
                    realm.add(imageInfo)
                })
            } catch let error as NSError {
                print("Error in RealmServices - loadImagesInfo: ", error)
            }
    }
   
    // сохранить массив
    public func saveImagesInfo(imagesInfo: [PhotoInfoRealmObject]/*, completion: @escaping(_ result: Bool) -> ()*/) {
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
                //try realm.commitWrite()
                //completion(true)
            } catch let error as NSError {
                print("Error in RealmServices - loadImagesInfo: ", error)
                //completion(false)
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
