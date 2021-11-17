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
    
    lazy var isPhotosInfoSaved: Bool = {
       return checkIfRealmIsNotEmpty()
    }()
    
    private init() {
        isPhotosInfoSaved = checkIfRealmIsNotEmpty()
    }
    
    private func checkIfRealmIsNotEmpty() -> Bool {
        do {
            let realm = try Realm()
            return realm.isEmpty
        } catch {
            print("Error in RealmServices - checkIfRealmIsNotEmpty")
        }
        return false
    }
   
    public func saveImagesInfo(imagesInfo: [PhotoInfoRealmObject]/*, completion: @escaping(_ result: Bool) -> ()*/) {
        do {
            let realm = try Realm()
            try realm.write({
                realm.deleteAll()
                realm.add(imagesInfo)
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
