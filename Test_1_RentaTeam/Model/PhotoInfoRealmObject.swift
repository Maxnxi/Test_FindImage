//
//  PhotoInfoRealmObject.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 10.11.2021.
//

import Foundation
import RealmSwift

class PhotoInfoRealmObject: Object {
    @Persisted(primaryKey: true) var photoId: String
    @Persisted var photographerName: String
    @Persisted var avgColor: String
    @Persisted var photoName: String
    @Persisted var urlPath: String
    @Persisted var dateOfDownloaded: Int
}
