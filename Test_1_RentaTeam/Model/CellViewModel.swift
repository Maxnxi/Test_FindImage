//
//  CellViewModel.swift
//  Test_1_RentaTeam
//
//  Created by Maksim Ponomarev on 09.11.2021.
//

import Foundation
import UIKit

class CellViewModel {
    
    let image: UIImage
    let id: String
    let photoGrapherName: String
    let downloadDate: String
    let url: String
    
    init(image: UIImage, id: String, photoGrapherName: String, downoladDate: String, url: String) {
        self.image = image
        self.id = id
        self.photoGrapherName = photoGrapherName
        self.downloadDate = downoladDate
        self.url = url
    }
}
