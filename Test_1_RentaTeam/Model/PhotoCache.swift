//
//  PhotoCache.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 09.11.2021.
//

import UIKit

class PhotoCache {
    let image: UIImage
    let dateOfDownloaded: Date
    
    init(image: UIImage, dateOfDownloaded: Date) {
        self.image = image
        self.dateOfDownloaded = dateOfDownloaded
    }
}
