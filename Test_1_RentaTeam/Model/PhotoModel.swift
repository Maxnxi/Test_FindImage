//
//  PhotoModel.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 09.11.2021.
//

import Foundation
import UIKit

protocol PhotableModel {
    var id: Int { get set }
    var photographer: String { get set }
    var avgColor: String { get set }
    var photoName: String { get set }
    var url: String { get set }
    var dateOfDownloaded: Int? { get set }
    var image: UIImage? { get set }
}

class PhotoModel: PhotableModel {
    
    var id: Int //3408744,
    var photographer: String //"stein egil liland",
    var avgColor: String //"#557088",
    var photoName: String
    var url: String //"https://images.pexels.com/photos/3408744/pexels-photo-3408744.jpeg?auto=compress&cs=tinysrgb&h=350"
    var dateOfDownloaded: Int?
    var image: UIImage?
        
    init(id: Int, photographer: String, averageColor: String, url: String) {
        self.id = id
        self.photographer = photographer
        self.avgColor = averageColor
        self.photoName = String(url.suffix(7))
        self.url = url
    }

}

class PhotoOfflineModel: PhotableModel {
    var id: Int
    var photographer: String
    var avgColor: String
    var photoName: String
    var url: String
    var dateOfDownloaded: Int?
    var image: UIImage?
    
    init(id: Int, photographer: String, averageColor: String, photoName: String, url: String, dateOfDownload: Int, image: UIImage) {
        self.id = id
        self.photographer = photographer
        self.avgColor = averageColor
        self.photoName = photoName
        self.url = url
        self.dateOfDownloaded = dateOfDownload
        self.image = image
    }
}
