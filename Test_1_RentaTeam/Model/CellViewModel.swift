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
    let downloadDate: Date
    
    init(image: UIImage, id: String, photoGrapherName: String, downoladDate: Date) {
        self.image = image
        self.id = id
        self.photoGrapherName = photoGrapherName
        self.downloadDate = downoladDate
    }
}
